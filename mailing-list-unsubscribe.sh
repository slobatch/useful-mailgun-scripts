#!/bin/bash

FILE=$1
LIST=$2
KEY=$3


if [ $FILE != "" ] && [ $KEY != "" ] && [ $LIST != "" ]; then
    echo "Reading file: $FILE"
    echo "List: $LIST"
    echo "Mailgun API Key: $KEY"
else
    echo "Expecting a file name AND mailing list AND API Key"
    echo "e.g. \`unsubscribe.sh file.csv website.com key-00x0xxxxxxxxx000xxx0xxx0xxxxxxx0\`"
    exit
fi

function unsubscribe {

  counter=0
  apiArgument="api:$KEY"
  echo $apiArgument
  while read p; do
    counter=`expr $counter + 1`
    echo "Unsubscribing email #$counter from list $LIST: "
    curl -s --user $apiArgument -X PUT \
        https://api.mailgun.net/v3/lists/$LIST/members/$p \
        -F subscribed=False
    echo
  done
  echo "Unsubscribed $counter users."
}

unsubscribe < $FILE
