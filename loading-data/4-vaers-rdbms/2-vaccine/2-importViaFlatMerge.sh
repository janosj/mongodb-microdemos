source ../mdb-uri.conf
source demo.conf

# Merge the Vaccine CSV data into the main document as top-level attributes.
# Assumes a 1:1 relationship between main and vaccine.
# This assumption may be entirely inaccurate, it's just for illustrative/discussion purposes.

mongoimport $MDB_CONNECT_URI --db=VAERS --collection=data --type=csv --headerline --file=$VACCINE_FILE --ignoreBlanks --mode=merge --upsertFields=VAERS_ID


