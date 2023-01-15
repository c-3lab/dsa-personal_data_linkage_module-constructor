#!/bin/bash

source .env

echo "DNS_STACK_NAME=$DNS_STACK_NAME"

# delete DNS stack
aws cloudformation delete-stack --stack-name $DNS_STACK_NAME
aws cloudformation wait stack-delete-complete --stack-name $DNS_STACK_NAME

