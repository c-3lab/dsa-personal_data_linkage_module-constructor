#!/bin/bash

source .env

echo "VPC_STACK_NAME=$VPC_STACK_NAME"

aws cloudformation delete-stack --stack-name $VPC_STACK_NAME
aws cloudformation wait stack-delete-complete --stack-name $VPC_STACK_NAME

