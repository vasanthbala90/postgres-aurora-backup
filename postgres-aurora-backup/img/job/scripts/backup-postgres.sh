#!/bin/bash

# Navigate to the temporary directory
cd /tmp

# PostgresDB authentication parameters
AUTH_PARAM="--username ${PGUSER} --password ${PGPASSWORD}"

# Get the current date and time for the backup filename
date1=$(date +%Y-%m-%d-%H%M)

# Define the backup filename including the date and namespace
file_name="$date1-$POSTGRES_NAMESPACE.tar"

# Log the start of the backup process
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting PostgresDB backup process..."

# Check if the backup directory already exists
if [ -d "postgres-aurora-backup" ]; then
    # If it exists, remove it and its contents, along with the backup tar file
    rm -rf postgres-aurora-backup $file_name
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Removed existing PostgresDB backup directory and the backup tar file."
fi

# Create the backup directory
mkdir postgres-aurora-backup
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Created PostgresDB backup directory."

# Connect to Aurora DB and store the listed the DB's into a File Db.txt
psql -h aurora-cluster-us-east-2.cluster-cufzhgd2jvkt.us-east-2.rds.amazonaws.com  -U uanalyze -d uanalyze_orgcus -p 5432 -t -c "select datname from pg_database where datname like '%uanalyze%'" > db.txt
sed -i '/^[[:space:]]*$/d' db.  ##For trimming the new line character
cat db.txt | while read line #Looping each uanalyze DB name from DB.txt
do
   echo $line
   pg_dump -h aurora-cluster-us-east-2.cluster-cufzhgd2jvkt.us-east-2.rds.amazonaws.com -p 5432 -U uanalyze -d $line -Fd -f pg-backup/$line
done


#Compressing backup file for upload
tar -zcvf $file_name postgres-aurora-backup

# Log that the backup has been successfully created
echo "[$(date '+%Y-%m-%d %H:%M:%S')] PostgresDB backup completed successfully."

# Uploading to s3
aws s3 cp $file_name "s3://$S3_BUCKET/$CLUSTER_NAME/$POSTGRES_NAMESPACE/`date +%Y/%m/%d`/"

# Log that the upload to S3 has been completed
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Uploading backup to Amazon S3 completed."

# Log and remove the backup directory and the backup tar file
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Removed PostgresDB backup directory and the backup tar file."
rm -rf postgres-aurora-backup $file_name