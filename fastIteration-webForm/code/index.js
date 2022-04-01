const { resolveCaa } = require('dns');
const express = require('express')
const path = require('path')
const app = express()

// Note: uses 8081 to leave 8080 available for Ops Manager or anything else.
const port = 8081

// MONGODB CONNECT STRING
// Example Atlas connect string. Put password in key.json file.
// const credentials = require('./key.json');
// const uri = `mongodb+srv://demo-user:${credentials.password}@atlas-cluster.mongodb.net/DEMO?retryWrites=true&w=majority`;
// More examples: locally installed test instances without access control enabled
// const uri = `mongodb://myserver1:27021/?readPreference=primary&appname=MongoDB%20Compass&ssl=false`;
// const uri = `mongodb://sandbox1:27017`;
// WARNING: using localhost here causes an error:
const uri = `mongodb://myserver1:27017`;

// Establish MDB connection on startup.
const MongoClient = require('mongodb').MongoClient;
const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });
client.connect(err => {
    if(err){
        console.log(err);
        reject(err);
    }
});

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname + '/web/index.html'));
})
app.use(express.static('web'));
app.use(express.json());

app.post('/insertDocument', (req, res) => {
    insertDocument(req.body).then((result) => {
        res.send(JSON.stringify(result));
    // }).catch(error => console.error(error))
    }).catch((error) => {
        // Send the error back to the browser.
        res.status(500).send(JSON.stringify(error));
    })
})

app.listen(port, () => console.log(`App listening on port ${port}! Access from browser at http://localhost:${port}/`))

function insertDocument(doc) {

    return new Promise(function (resolve, reject) {

        //const collection = client.db("DEMO").collection("workflow");
        //collection.insertOne(doc).then((result) => {
        //    resolve(result);
        //});

        // Updated to propagate errors.
        const collection = client.db("DEMO").collection("workflow");
        collection.insertOne(doc, (err, res) => {
            if (err) {
                console.log('error', err);
                reject(err);
            } else {
                console.log('\ninserted record', res.ops[0]);
                resolve(res.ops[0]);
            }
        });

    });

}
