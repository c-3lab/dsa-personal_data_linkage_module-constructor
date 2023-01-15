#!/bin/bash

source .env
echo "ECR_STACK_NAME=$ECR_STACK_NAME"

ACCOUNTID=$(aws sts get-caller-identity --query "Account" --output text);echo "ACCOUNTID=$ACCOUNTID"

# create ecr repositories
aws cloudformation create-stack --region ap-northeast-1 --stack-name $ECR_STACK_NAME --template-body file://CFn/ecr.yaml
aws cloudformation wait stack-create-complete --stack-name $ECR_STACK_NAME
aws cloudformation describe-stacks --stack-name $ECR_STACK_NAME

# push images
## get login password
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com
## pxr-access-control-manage-service
docker tag pxr/pxr-access-control-manage-service:1.0 $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-access-control-manage-service:1.0
docker push $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-access-control-manage-service:1.0

## pxr-access-control-service
docker tag pxr/pxr-access-control-service:1.0 $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-access-control-service:1.0
docker push $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-access-control-service:1.0

## pxr-binary-manage-service
docker tag pxr/pxr-binary-manage-service:1.0 $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-binary-manage-service:1.0
docker push $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-binary-manage-service:1.0

## pxr-block-proxy-service
docker tag pxr/pxr-block-proxy-service:1.0 $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-block-proxy-service:1.0
docker push $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-block-proxy-service:1.0

## pxr-book-manage-service
docker tag pxr/pxr-book-manage-service:1.0 $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-book-manage-service:1.0
docker push $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-book-manage-service:1.0

## pxr-book-operate-service
docker tag pxr/pxr-book-operate-service:1.0 $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-book-operate-service:1.0
docker push $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-book-operate-service:1.0

## pxr-catalog-service
docker tag pxr/pxr-catalog-service:1.0 $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-catalog-service:1.0
docker push $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-catalog-service:1.0

## pxr-catalog-update-service
docker tag pxr/pxr-catalog-update-service:1.0 $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-catalog-update-service:1.0
docker push $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-catalog-update-service:1.0

## pxr-certificate-manage-service
docker tag pxr/pxr-certificate-manage-service:1.0 $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-certificate-manage-service:1.0
docker push $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-certificate-manage-service:1.0

## pxr-certification-authority-service
docker tag pxr/pxr-certification-authority-service:1.0 $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-certification-authority-service:1.0
docker push $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-certification-authority-service:1.0

## pxr-ctoken-ledger-service
docker tag pxr/pxr-ctoken-ledger-service:1.0 $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-ctoken-ledger-service:1.0
docker push $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-ctoken-ledger-service:1.0

## pxr-identity-verificate-service
docker tag pxr/pxr-identity-verificate-service:1.0 $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-identity-verificate-service:1.0
docker push $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-identity-verificate-service:1.0

## pxr-local-ctoken-service
docker tag pxr/pxr-local-ctoken-service:1.0 $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-local-ctoken-service:1.0
docker push $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-local-ctoken-service:1.0

## pxr-notification-service
docker tag pxr/pxr-notification-service:1.0 $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-notification-service:1.0
docker push $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-notification-service:1.0

## pxr-operator-service
docker tag pxr/pxr-operator-service:1.0 $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-operator-service:1.0
docker push $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com/pxr-operator-service:1.0

