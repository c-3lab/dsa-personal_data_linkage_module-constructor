#!/bin/bash

source .env

echo "VPC_STACK_NAME=$VPC_STACK_NAME"
echo "NAMESPACE=$NAMESPACE"

CLUSTER_NAME=$(aws cloudformation describe-stacks --stack-name $VPC_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$VPC_STACK_NAME-EKS-cluster-name'].OutputValue" --output text); echo "CLUSTER_NAME=$CLUSTER_NAME"
VPCID=$(aws cloudformation describe-stacks --stack-name $VPC_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$VPC_STACK_NAME-vpc'].OutputValue" --output text); echo "VPCID=$VPCID"
PRISNID1=$(aws cloudformation describe-stacks --stack-name $VPC_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$VPC_STACK_NAME-private-subnet-a'].OutputValue" --output text); echo "PRISNID1=$PRISNID1"
PRISNID2=$(aws cloudformation describe-stacks --stack-name $VPC_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$VPC_STACK_NAME-private-subnet-c'].OutputValue" --output text); echo "PRISNID2=$PRISNID2"
PRISNID3=$(aws cloudformation describe-stacks --stack-name $VPC_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$VPC_STACK_NAME-private-subnet-d'].OutputValue" --output text); echo "PRISNID3=$PRISNID3"
PUBSNID1=$(aws cloudformation describe-stacks --stack-name $VPC_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$VPC_STACK_NAME-public-subnet-a'].OutputValue" --output text); echo "PUBSNID1=$PUBSNID1"
PUBSNID2=$(aws cloudformation describe-stacks --stack-name $VPC_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$VPC_STACK_NAME-public-subnet-c'].OutputValue" --output text); echo "PUBSNID2=$PUBSNID2"
PUBSNID3=$(aws cloudformation describe-stacks --stack-name $VPC_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$VPC_STACK_NAME-public-subnet-d'].OutputValue" --output text); echo "PUBSNID3=$PUBSNID3"

# create an EKS
eksctl create cluster \
--region ap-northeast-1 \
--name $CLUSTER_NAME \
--version 1.20 \
--fargate \
--vpc-private-subnets $PRISNID1,$PRISNID2,$PRISNID3 \
--vpc-public-subnets $PUBSNID1,$PUBSNID2,$PUBSNID3 \
--tags "Owner=owner, Group=platform, Name=$CLUSTER_NAME"

aws eks update-kubeconfig \
--region ap-northeast-1 \
--name $CLUSTER_NAME

kubectl create namespace $NAMESPACE

eksctl create fargateprofile \
--region ap-northeast-1 \
--cluster $CLUSTER_NAME \
--name $CLUSTER_NAME-profile \
--namespace $NAMESPACE \
--tags "Name=$CLUSTER_NAME-profile"

eksctl get cluster \
--region ap-northeast-1 \
--name $CLUSTER_NAME

eksctl utils associate-iam-oidc-provider \
--region ap-northeast-1 \
--cluster $CLUSTER_NAME \
--approve

# set up alb-ingress-controller
mkdir -p ./alb-ingress-config
curl -o alb-ingress-config/alb-ingress-controller.yaml https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.7/docs/examples/alb-ingress-controller.yaml
curl -o alb-ingress-config/iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.7/docs/examples/iam-policy.json
curl -o alb-ingress-config/rbac-role.yaml https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.7/docs/examples/rbac-role.yaml

SED="docker run --rm -v $(pwd)/alb-ingress-config:/opt/ busybox:1.36 sed"

$SED -i -e "s/            # - --cluster-name=devCluster/            - --cluster-name=$CLUSTER_NAME/" \
        -e "s/            # - --aws-vpc-id=vpc-xxxxxx/            - --aws-vpc-id=$VPCID/" \
        -e "s/            # - --aws-region=us-west-1/            - --aws-region=ap-northeast-1/" \
        /opt/alb-ingress-controller.yaml

POLICYARN=$(aws iam create-policy --policy-name $CLUSTER_NAME-ingress-policy --policy-document file://alb-ingress-config/iam-policy.json --query Policy.Arn --output text);echo "POLICYARN=$POLICYARN"

kubectl apply -f alb-ingress-config/rbac-role.yaml

eksctl create iamserviceaccount \
--region ap-northeast-1 \
--cluster $CLUSTER_NAME \
--name alb-ingress-controller \
--namespace kube-system \
--attach-policy-arn $POLICYARN \
--override-existing-serviceaccounts \
--approve

kubectl apply -f alb-ingress-config/alb-ingress-controller.yaml

