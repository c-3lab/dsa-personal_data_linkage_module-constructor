#!/bin/bash

VPC_STACK_NAME=pxr-vpc
RDS_STACK_NAME=pxr-rds

DB_NAME="pxr_db"
DB_USER_PASSWORD="postgresPass"

# create vpc
aws cloudformation create-stack --region ap-northeast-1 --stack-name $RDS_STACK_NAME --template-body file://CFn/rds.yaml \
  --parameters ParameterKey=VpcStackName,ParameterValue=$VPC_STACK_NAME \
               ParameterKey=DBName,ParameterValue=$DB_NAME \
               ParameterKey=DBUserPassword,ParameterValue=$DB_USER_PASSWORD
aws cloudformation wait stack-create-complete --stack-name $RDS_STACK_NAME
aws cloudformation describe-stacks --stack-name $RDS_STACK_NAME

