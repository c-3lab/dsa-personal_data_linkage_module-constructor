#!/bin/bash

VPC_STACK_NAME=pxr-vpc

ACCOUNTID=$(aws sts get-caller-identity --query "Account" --output text);echo "ACCOUNTID=$ACCOUNTID"
CLUSTER_NAME=$(aws cloudformation describe-stacks --stack-name $VPC_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$VPC_STACK_NAME-EKS-cluster-name'].OutputValue" --output text); echo "CLUSTER_NAME=$CLUSTER_NAME"


kubectl delete -f alb-ingress-config/alb-ingress-controller.yaml

kubectl delete -f alb-ingress-config/rbac-role.yaml

eksctl delete fargateprofile \
--region ap-northeast-1 \
--cluster $CLUSTER_NAME \
--name $CLUSTER_NAME-profile

eksctl delete cluster \
--region ap-northeast-1 \
--name $CLUSTER_NAME

eksctl delete iamserviceaccount \
--region ap-northeast-1 \
--cluster $CLUSTER_NAME \
--name alb-ingress-controller

aws iam delete-policy --policy-arn "arn:aws:iam::$ACCOUNTID:policy/$CLUSTER_NAME-ingress-policy"

