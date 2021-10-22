source ../mdb-uri.conf
source demo.conf

# Import the Symptom CSV data file as a separate collection.

mongoimport $MDB_CONNECT_URI --db=VAERS --collection=symptoms --type=csv --headerline --file=$SYMPTOMS_FILE --ignoreBlanks


