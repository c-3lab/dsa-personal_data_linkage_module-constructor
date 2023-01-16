#!/bin/bash

source .env

echo "ACM_STACK_NAME=$ACM_STACK_NAME"
echo "WEBACL_STACK_NAME=$WEBACL_STACK_NAME"

ACM_ARN=$(aws cloudformation describe-stacks --stack-name $ACM_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$ACM_STACK_NAME-acm'].OutputValue" --output text); echo "ACM_ARN=$ACM_ARN"

# delete a Route53 Record used ACM Validation
RECORD_NAME=$(aws acm describe-certificate --certificate-arn ${ACM_ARN} --query "Certificate.DomainValidationOptions[0].ResourceRecord.Name" --output text); echo "RACORD_NAME=$RECORD_NAME"
RECORD_VALUE=$(aws acm describe-certificate --certificate-arn ${ACM_ARN} --query "Certificate.DomainValidationOptions[0].ResourceRecord.Value" --output text); echo "RECORD_VALUE=$RECORD_VALUE"

# set validate record
ZONE_ID=$(aws route53 list-hosted-zones --query "HostedZones[?Name=='${DOMAIN}.'].Id" --output text); echo "ZONE_ID=$ZONE_ID"
aws route53 change-resource-record-sets --hosted-zone-id $ZONE_ID --change-batch \
"{
  \"Changes\": [
    {
      \"Action\": \"DELETE\",
      \"ResourceRecordSet\": {
        \"Name\": \"$RECORD_NAME\",
        \"Type\": \"CNAME\",
        \"TTL\": 300,
        \"ResourceRecords\": [{\"Value\": \"$RECORD_VALUE\"}]
      }
    }
  ]
}"

# delete WebSCL stack
aws cloudformation delete-stack --stack-name $WEBACL_STACK_NAME
aws cloudformation wait stack-delete-complete --stack-name $WEBACL_STACK_NAME

# delete ACM stack
aws cloudformation delete-stack --stack-name $ACM_STACK_NAME
aws cloudformation wait stack-delete-complete --stack-name $ACM_STACK_NAME

