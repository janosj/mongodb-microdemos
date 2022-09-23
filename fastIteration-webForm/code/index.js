const express = require('express')
const path = require('path');
const { exit } = require('process');
const app = express()

// Reconfigured logging to write to console + file.
// File logging is useful for troubleshooting with Kubernetes.
var fs = require('fs');
var util = require('util');
var log_file = fs.createWriteStream('debug/debug.log', {flags : 'w'});
var log_stdout = process.stdout;
console.log = function(d) {
    log_file.write(util.format(d) + '\n');
    log_stdout.write(util.format(d) + '\n');
};

uri = process.env.URI;
if (uri) {
    console.log(`Starting app with MONGODB URI = ${uri}`);
} else {
    console.log("WARNING! No database connection, MongoDB URI not provided.");
    console.log("Usage: URI=<mdb-uri> node index.js");
    console.log("");
}

// Note: uses 8081 to leave 8080 available for Ops Manager or anything else.
const port = 8081

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

        // Returned MDB connection to inside insertDocument.
        // Had moved it previously to connect on startup.
        // Putting it here allows connections to be re-established as needed.
        const MongoClient = require('mongodb').MongoClient;
        const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });
        client.connect(err => {
            if(err){
                console.log(`ERROR connecting to MongoDB! MDB_URI is: ${uri}`);
                console.log(err);
                reject(err);
            }
        });

        // Updated to propagate errors.
        const collection = client.db("DEMO").collection("workflow");
        collection.insertOne(doc, (err, res) => {
            if (err) {
                console.log(err);
                reject(err);
            } else {
                console.log('\ninserted record');
                console.log(res.ops[0]);
                resolve(res.ops[0]);
            }
        });

    });

}
