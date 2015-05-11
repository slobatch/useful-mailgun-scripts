#!/bin/bash


FILE=$1
KEY=$2

if [ $FILE != "" ] && [ $KEY != "" ]; then
    echo "Reading file: $FILE"
    echo "Mailgun API Key: $KEY"
else
    echo "Expecting a file name AND API Key"
    echo "e.g. \`unsubscribe.sh file.csv key-00x0xxxxxxxxx000xxx0xxx0xxxxxxx0\`"
    exit
fi

function unsubscribe {

  counter=0
  apiArgument='api:'$KEY
  while read p; do
    counter=`expr $counter + 1`
    echo "Unsubscribing email $counter: "
    curl -s --user 'api:'$KEY \
      https://api.mailgun.net/v3/props.knotable.com/unsubscribes \
      -F address=$p \
      -F tag='*'
    echo
  done
  echo "Unsubscribed $counter users."
}

unsubscribe < $FILE
