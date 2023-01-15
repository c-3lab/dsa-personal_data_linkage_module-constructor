#!/bin/bash

VPC_STACK_NAME=pxr-vpc

DOMAIN_NAME=pxr

# create a CloudSearch
aws cloudsearch create-domain --domain-name $DOMAIN_NAME
aws cloudsearch define-index-field \
--domain-name $DOMAIN_NAME \
--name description \
--type text \
--return-enabled true \
--sort-enabled true \
--highlight-enabled true \
--analysis-scheme _ja_default_

# create indexes
aws cloudsearch define-index-field \
--domain-name $DOMAIN_NAME \
--name name \
--type text \
--return-enabled true \
--sort-enabled true \
--highlight-enabled true \
--analysis-scheme _ja_default_

aws cloudsearch define-index-field \
--domain-name $DOMAIN_NAME \
--name code \
--type int \
--facet-enabled true \
--return-enabled true \
--sort-enabled true

aws cloudsearch define-index-field \
--domain-name $DOMAIN_NAME \
--name id \
--type int \
--facet-enabled true \
--return-enabled true \
--sort-enabled true

aws cloudsearch index-documents --domain-name $DOMAIN_NAME

# create a access policy
EIP1=$(aws cloudformation describe-stacks --stack-name $VPC_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$VPC_STACK_NAME-EIP-a'].OutputValue" --output text); echo "EIP1=$EIP1"
EIP2=$(aws cloudformation describe-stacks --stack-name $VPC_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$VPC_STACK_NAME-EIP-c'].OutputValue" --output text); echo "EIP2=$EIP2"
EIP3=$(aws cloudformation describe-stacks --stack-name $VPC_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$VPC_STACK_NAME-EIP-d'].OutputValue" --output text); echo "EIP3=$EIP3"

aws cloudsearch update-service-access-policies --domain-name pxr --access-policies \
  "{\"Version\":\"2012-10-17\",
    \"Statement\":[{
      \"Sid\":\"eip1\",
      \"Effect\":\"Allow\",
      \"Principal\":{\"AWS\":\"*\"},
      \"Action\":\"cloudsearch:*\",
      \"Condition\":{
        \"IpAddress\":{
          \"aws:SourceIp\":[
            \"$EIP1/32\",\"$EIP2/32\",\"$EIP3/32\"
            ]
          }
        }
      }
    ]
  }"

function get_state () {
  echo $(aws cloudsearch describe-domains --query "DomainStatusList[?DomainName=='$DOMAIN_NAME'].Processing" --output text)
}

PROCESSING="True"
while [ $PROCESSING == "True" ]; do
  sleep 10
  PROCESSING=$(get_state)
  echo "PROCESSING=$PROCESSING"
done

# get endpoints
SEARCH_ENDPOINT=$(aws cloudsearch describe-domains --query "DomainStatusList[?DomainName=='$DOMAIN_NAME'].SearchService.Endpoint" --output text);echo "SEARCH_ENDPOINT=$SEARCH_ENDPOINT"
DOC_ENDPOINT=$(aws cloudsearch describe-domains --query "DomainStatusList[?DomainName=='$DOMAIN_NAME'].DocService.Endpoint" --output text);echo "DOC_ENDPOINT=$DOC_ENDPOINT"

