#!/bin/bash

source .env

echo "VPC_STACK_NAME=$VPC_STACK_NAME"

ACCOUNTID=$(aws sts get-caller-identity --query "Account" --output text);echo "ACCOUNTID=$ACCOUNTID"
CLUSTER_NAME=$(aws cloudformation describe-stacks --stack-name $VPC_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$VPC_STACK_NAME-EKS-cluster-name'].OutputValue" --output text); echo "CLUSTER_NAME=$CLUSTER_NAME"

SEDi="docker run -i --rm -v $(pwd)/src:/opt/src -w /opt busybox:1.36 sed"

kubectl delete -f alb-ingress-config/alb-ingress-controller.yaml

eksctl delete iamserviceaccount \
--region ap-northeast-1 \
--cluster $CLUSTER_NAME \
--name alb-ingress-controller

kubectl delete -f alb-ingress-config/rbac-role.yaml

eksctl delete fargateprofile \
--region ap-northeast-1 \
--cluster $CLUSTER_NAME \
--name $CLUSTER_NAME-profile

while :; do
  STATUS=$(eksctl get fargateprofile --cluster $CLUSTER_NAME --name $CLUSTER_NAME-profile -o yaml 2> /dev/null | $SEDi -n -e 's/^.*status: \(.*\)$/\1/p')
  if [ -z $STATUS ]; then
    break
  fi
  echo "STATUS=$STATUS"
  sleep 10
done

eksctl delete cluster \
--region ap-northeast-1 \
--name $CLUSTER_NAME

while :; do
  STATUS=$(eksctl get cluster --name $CLUSTER_NAME -o yaml 2> /dev/null | $SEDi -n -e 's/^.*status: \(.*\)$/\1/p')
  if [ -z $STATUS ]; then
    break
  fi
  echo "STATUS=$STATUS"
  sleep 10
done
aws cloudformation wait stack-delete-complete --stack-name eksctl-$CLUSTER_NAME-cluster

aws iam delete-policy --policy-arn "arn:aws:iam::$ACCOUNTID:policy/$CLUSTER_NAME-ingress-policy"
#
