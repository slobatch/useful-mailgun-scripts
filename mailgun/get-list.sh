#!/bin/bash


LIST=$1
KEY=$2
OUTPUT=$3

if [ $LIST != "" ] && [ $KEY != "" ]; then
    echo "Mailgun List: $LIST"
    echo "Mailgun API Key: $KEY"
else
    echo "Expecting mailing list address AND API Key AND output file"
    echo "e.g. \`get-list.sh email@website.com key-00x0xxxxxxxxx000xxx0xxx0xxxxxxx0 output.txt\`"
    exit
fi

function getList {
  touch $OUTPUT
  apiArgument="api:$KEY"
  echo $apiArgument
  curl -s --user $apiArgument -G "https://api.mailgun.net/v3/lists/$LIST/members" > tmp.json
  entries=$(jq .'total_count' tmp.json)
  echo "Exporting " $entries " addresses."
  skip=0
  while [ $skip -lt $entries ]; do
    echo "Skipping $skip"
    curl -s --user $apiArgument -G "https://api.mailgun.net/v3/lists/$LIST/members?subscribed=yes&skip=$skip" > tmp2.json
    batchLength=$(jq '.items | length' tmp2.json)

    counter=0
    while [ $counter -lt $batchLength ]; do
      echo "Batch: "$skip" | entry: "$counter
      address=$(jq ".items[$counter].address" tmp2.json)
      eval echo $address
      eval echo $address >> $OUTPUT
      counter=$((counter+1))
    done
    skip=$((skip+100))
  done
  rm tmp.json
  rm tmp2.json
}

getList

# key-63r1aardtcyto350ctg7hpm5bxxewgf2
# 0asarvacopr@m.sarva.co
