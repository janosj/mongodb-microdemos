source ../mdb-uri.conf
source demo.conf

# Recodes the CSV headerline to model the vaccine data as a subdocument in the main document.

cp $VACCINE_FILE $RECODED_FILE

sed -i "" 's/VAX_/vaccine./g' $RECODED_FILE

