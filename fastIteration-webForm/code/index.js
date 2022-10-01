const express = require('express')
const path = require('path');
const { exit } = require('process');
const app = express()

// Reconfigured logging to write to console + file.
// Introduced to support troubleshooting on Kubernetes.
var fs = require('fs');
var util = require('util');
var log_file = fs.createWriteStream('debug/debug.log', {flags : 'w'});
var log_stdout = process.stdout;
console.log = function(d) {
    log_file.write(util.format(d) + '\n');
    log_stdout.write(util.format(d) + '\n');
};

// Pick up the MongoDB URI as an environment variable.
uri = process.env.URI;
const MongoClient = require('mongodb').MongoClient;
const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true, serverSelectionTimeoutMS: 4000 });
if (uri) {
    console.log(`Starting app with MONGODB URI = ${uri}`);
} else {
    console.log("WARNING! No database connection, MongoDB URI not provided.");
    console.log("Usage: URI=<mdb-uri> node index.js");
    console.log("");
}

// Note: uses 8081 to leave 8080 available for Ops Manager or anything else.
const port = 8081

app.use(express.static('web'));

// parses incoming json requests and puts parsed data into request.body.
app.use(express.json());

app.get('/', (request, response) => {
    response.sendFile(path.join(__dirname + '/web/index.html'));
})

app.post('/insertDocument', async (request, response) => {

//    const MongoClient = require('mongodb').MongoClient;
//    const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true, serverSelectionTimeoutMS: 4000 });
    
    client.connect().then(

        function() {

            console.log("\nEstablished database connection.");
            const collection = client.db("DEMO").collection("workflow");

            collection.insertOne(request.body).then( (result) => {
                response.send(JSON.stringify(result));
                console.log('Inserted document:');
                console.log(result.ops[0]);
            }).catch( error => { 
                console.error("Error caught while inserting document:");  
                console.error(error);
                response.status(500).send(error);
            });

        }

    ).catch( (error) => {
        console.error("ERROR in /insertDocument while trying to connect to MongoDB.");
        console.error(error);
        response.status(500).send(error);
    } )

})

app.listen(port, () => console.log(`App listening on port ${port}! Access from browser at http://localhost:${port}/`))
