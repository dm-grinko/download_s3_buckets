#!/usr/bin/env bash
# file: download.sh 

# ./download.sh -p myProfileName

# default value
aws_pofile=default

# get aws_pofile name
while getopts p: flag
do
    case "${flag}" in
        p) pofile=${OPTARG};; 
    esac
done

# save the "aws s3 ls" command response into the temp.txt file
aws s3 ls --profile rwdvs --output text > temp.txt 

# get the file row count
bucket_count="`grep "" -c temp.txt`"
# default value
current_bucket=0 

while read r; do # for each row of the temp.txt
    data=(${r// / }) # split a row by spaces 
    bucket_name=${data[2]}
    # download bucket data
    aws s3 sync "s3://$bucket_name" "./s3/$bucket_name/" --profile $aws_pofile

    current_bucket=$((current_bucket+1)) # Increment
    echo "${current_bucket} / ${bucket_count}" # show progress
done <temp.txt

rm ./temp.txt

echo "Done!"