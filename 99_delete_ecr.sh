#!/bin/bash

source .env

echo "ECR_STACK_NAME=$ECR_STACK_NAME"

# delete images
aws ecr batch-delete-image --repository-name pxr-access-control-manage-service --image-ids imageTag=1.0
aws ecr batch-delete-image --repository-name pxr-access-control-service --image-ids imageTag=1.0
aws ecr batch-delete-image --repository-name pxr-binary-manage-service --image-ids imageTag=1.0
aws ecr batch-delete-image --repository-name pxr-block-proxy-service --image-ids imageTag=1.0
aws ecr batch-delete-image --repository-name pxr-book-manage-service --image-ids imageTag=1.0
aws ecr batch-delete-image --repository-name pxr-book-operate-service --image-ids imageTag=1.0
aws ecr batch-delete-image --repository-name pxr-catalog-service --image-ids imageTag=1.0
aws ecr batch-delete-image --repository-name pxr-catalog-update-service --image-ids imageTag=1.0
aws ecr batch-delete-image --repository-name pxr-certificate-manage-service --image-ids imageTag=1.0
aws ecr batch-delete-image --repository-name pxr-certification-authority-service --image-ids imageTag=1.0
aws ecr batch-delete-image --repository-name pxr-ctoken-ledger-service --image-ids imageTag=1.0
aws ecr batch-delete-image --repository-name pxr-identity-verificate-service --image-ids imageTag=1.0
aws ecr batch-delete-image --repository-name pxr-local-ctoken-service --image-ids imageTag=1.0
aws ecr batch-delete-image --repository-name pxr-notification-service --image-ids imageTag=1.0
aws ecr batch-delete-image --repository-name pxr-operator-service --image-ids imageTag=1.0

# delete ecr repositories
aws cloudformation delete-stack --stack-name $ECR_STACK_NAME
aws cloudformation wait stack-delete-complete --stack-name $ECR_STACK_NAME

