#!/bin/bash

source .env

echo "RDS_STACK_NAME=$RDS_STACK_NAME"

aws cloudformation delete-stack --stack-name $RDS_STACK_NAME
aws cloudformation wait stack-delete-complete --stack-name $RDS_STACK_NAME

