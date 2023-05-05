#!/bin/bash

source .env

echo "VPC_STACK_NAME=$VPC_STACK_NAME"
echo "NAMESPACE=$NAMESPACE"
echo "EKS_VERSION=$EKS_VERSION"

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
--version $EKS_VERSION \
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

# set up AWS Load Balancer Controller
mkdir -p ./alb-manifests
curl -o alb-manifests/iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.7/docs/install/iam_policy.json

POLICYARN=$(aws iam create-policy --policy-name $CLUSTER_NAME-alb-policy --policy-document file://alb-manifests/iam_policy.json --query Policy.Arn --output text);echo "POLICYARN=$POLICYARN"

eksctl create iamserviceaccount \
--region ap-northeast-1 \
--cluster $CLUSTER_NAME \
--name aws-load-balancer-controller \
--namespace kube-system \
--role-name AmazonEKSLoadBalancerControllerRole \
--attach-policy-arn $POLICYARN \
--override-existing-serviceaccounts \
--approve

helm repo add eks https://aws.github.io/eks-charts
helm repo update

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set region=ap-northeast-1 \
  --set vpcId=$VPCID \
  --set clusterName=$CLUSTER_NAME \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller

kubectl wait -n kube-system --timeout=90s --for=condition=available deployment/aws-load-balancer-controller

