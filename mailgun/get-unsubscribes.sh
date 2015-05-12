#!/bin/bash


LIST=$1
SIZE=$2
KEY=$3

if [ $LIST != "" ] && [ $KEY != "" ]; then
    echo "Mailgun List: $LIST"
    echo "Mailgun API Key: $KEY"
else
    echo "Expecting mailing list address AND size AND API Key"
    echo "e.g. \`get-unsubscribes.sh email@website.com 900 key-00x0xxxxxxxxx000xxx0xxx0xxxxxxx0\`"
    exit
fi

function unsubscribe {

  skip=0
  apiArgument="api:$KEY"
  echo $apiArgument
  while [ $skip -lt $SIZE ]; do
    echo "Skipping $skip"
    curl -s --user $apiArgument -G \
    "https://api.mailgun.net/v3/lists/$LIST/members?subscribed=no&skip=$skip" > ~/Desktop/unsubscribed$skip.json
    skip=$((skip+100))
  done
  echo "Skipped: $skip"
}

unsubscribe
