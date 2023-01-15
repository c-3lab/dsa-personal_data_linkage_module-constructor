#!/bin/bash

DOMAIN_NAME=pxr

aws cloudsearch delete-domain --domain-name $DOMAIN_NAME

function get_state () {
  echo $(aws cloudsearch describe-domains --query "DomainStatusList[?DomainName=='$DOMAIN_NAME'].Processing" --output text)
}

PROCESSING="True"
while [ -n $PROCESSING ] || [ $PROCESSING == "True" ]; do
  PROCESSING=$(get_state)
  echo "PROCESSING=$PROCESSING"
  if [ -z $PROCESSING ]; then
    break
  fi
  sleep 10
done

