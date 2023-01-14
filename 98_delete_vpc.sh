#!/bin/bash

VPC_STACK_NAME=pxr-vpc

aws cloudformation delete-stack --stack-name $VPC_STACK_NAME
aws cloudformation wait stack-delete-complete --stack-name $VPC_STACK_NAME

