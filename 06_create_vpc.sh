#!/bin/bash

CLUSTER_NAME=pxr

VPC_STACK_NAME=pxr-vpc

# create vpc
aws cloudformation create-stack --region ap-northeast-1 --stack-name $VPC_STACK_NAME --template-body file://CFn/vpc.yaml \
  --parameters ParameterKey=EKSClusterName,ParameterValue=$CLUSTER_NAME
aws cloudformation wait stack-create-complete --stack-name $VPC_STACK_NAME
aws cloudformation describe-stacks --stack-name $VPC_STACK_NAME

