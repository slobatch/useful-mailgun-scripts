#!/bin/bash


FILE=$1
DOMAIN=$2
KEY=$3


if [ $FILE != "" ] && [ $KEY != "" ] && [ $DOMAIN != "" ]; then
    echo "Reading file: $FILE"
    echo "Mailgun API Key: $KEY"
else
    echo "Expecting a file name AND domain AND API Key"
    echo "e.g. \`unsubscribe.sh file.csv website.com key-00x0xxxxxxxxx000xxx0xxx0xxxxxxx0\`"
    exit
fi

function unsubscribe {

  counter=0
  apiArgument="api:$KEY"
  echo $apiArgument
  while read p; do
    counter=`expr $counter + 1`
    echo "Unsubscribing email $counter: "
    curl -s --user $apiArgument \
      https://api.mailgun.net/v3/$DOMAIN/unsubscribes \
      -F address=$p \
      -F tag='*'
    echo
  done
  echo "Unsubscribed $counter users."
}

unsubscribe < $FILE
