#!/bin/bash

source .env

echo "VPC_STACK_NAME=$VPC_STACK_NAME"
echo "RDS_STACK_NAME=$RDS_STACK_NAME"
echo "DB_NAME=$DB_NAME"
echo "DB_VERSION=$DB_VERSION"

# create vpc
aws cloudformation create-stack --region ap-northeast-1 --stack-name $RDS_STACK_NAME --template-body file://CFn/rds.yaml \
  --parameters ParameterKey=VpcStackName,ParameterValue=$VPC_STACK_NAME \
               ParameterKey=DBName,ParameterValue=$DB_NAME \
               ParameterKey=DBUserPassword,ParameterValue=$DB_USER_PASSWORD \
               ParameterKey=DBVersion,ParameterValue=$DB_VERSION
aws cloudformation wait stack-create-complete --stack-name $RDS_STACK_NAME
aws cloudformation describe-stacks --stack-name $RDS_STACK_NAME

