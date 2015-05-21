#!/bin/bash


IFILE=$1
OFILE=$2
INOFILE=$3
KEY=$4

if [[ $IFILE && $KEY && $OFILE ]]; then
    echo "Input file: $IFILE"
    echo "Output file: $OFILE"
    echo "Mailgun API Key: $KEY"
else
    echo "Expecting Input and Output file AND API Key"
    echo "e.g. \`validate-emails.sh ifile.txt ofile.txt key-00x0xxxxxxxxx000xxx0xxx0xxxxxxx0\`"
    exit
fi

function validate-emails {

  apiArgument="api:$KEY"
  # echo "apiArguement: $apiArgument"
  counter=0
  while read line; do
    # echo "Validating $line"
    json=$(curl -s --user $apiArgument -G "https://api.mailgun.net/v3/address/validate" --data-urlencode address="$line")
    echo $json > tmp.json
    isValid=$(jq '.is_valid' tmp.json)
    # echo "isValid $isValid"
    if [[ $isValid == "true" ]]; then
      echo "    VALID ==> $line"
      echo $line >> $OFILE
    else
      echo "NOT VALID ==> $line"
      if [[ $INOFILE ]]; then
        echo $line >> $INOFILE
      fi
    fi
    counter=`expr $counter + 1`
  done
  echo "Validated $counter emails"
  rm tmp.json
}

echo "Starting Script"
validate-emails < $IFILE
