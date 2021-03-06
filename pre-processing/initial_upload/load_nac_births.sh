#!/bin/sh
export HOST=
export USER=
export DB=mexico
export PGPASSWORD=""
export DIRECTORY=/Users/Nicke/desktop/dssg/mexico/data/working_folder/new_births
export SCHEMA="nac_births"

# Note: for preprocessing I stuck all of the deaths DBF files together in the same directory (they were in different ones before). I renamed them all using the same convention (def{year}) with the exception of 2012 since 2012 has multiple files associated with it. The 2012 convention is def2012{file}. This script is not robust to white spaces in the file names.

# Create schema
psql -h $HOST -U $USER $DB -c "CREATE SCHEMA IF NOT EXISTS $SCHEMA;"

# For each dbf file in directory, drop and create tables
for FILE in $(find $DIRECTORY -name "*.dbf" -exec basename \{} .dbf \;); do

	psql -h $HOST -U $USER $DB -c "DROP TABLE IF EXISTS $SCHEMA.$FILE;"

	ogr2ogr -f PostgreSQL \
		PG:"host=$HOST user=$USER dbname=$DB password=$PGPASSWORD" \
		"$DIRECTORY/$FILE.dbf" -nln "$SCHEMA.$FILE" \
	
done

