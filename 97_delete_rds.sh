#!/bin/bash

RDS_STACK_NAME=pxr-rds

aws cloudformation delete-stack --stack-name $RDS_STACK_NAME
aws cloudformation wait stack-delete-complete --stack-name $RDS_STACK_NAME

