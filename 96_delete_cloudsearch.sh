#!/bin/bash

source .env

echo "CLOUD_SEARCH_DOMAIN_NAME=$CLOUD_SEARCH_DOMAIN_NAME"

aws cloudsearch delete-domain --domain-name $CLOUD_SEARCH_DOMAIN_NAME

function get_state () {
  echo $(aws cloudsearch describe-domains --query "DomainStatusList[?DomainName=='$CLOUD_SEARCH_DOMAIN_NAME'].Processing" --output text)
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

