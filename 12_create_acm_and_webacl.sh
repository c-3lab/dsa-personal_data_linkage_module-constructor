#!/bin/bash

source .env

echo "ACM_STACK_NAME=$ACM_STACK_NAME"
echo "WEBACL_STACK_NAME=$WEBACL_STACK_NAME"
echo "DOMAIN=$DOMAIN"

ZONE_STR=$(aws route53 list-hosted-zones --query "HostedZones[?Name=='${DOMAIN}.'].Id" --output text)
SPLITTED=(${ZONE_STR//\// })
ZONE_ID=${SPLITTED[1]}; echo "ZONE_ID=$ZONE_ID"

# create ACM
aws cloudformation create-stack --region ap-northeast-1 --stack-name $ACM_STACK_NAME --template-body file://CFn/acm.yaml \
  --parameters ParameterKey=DomainName,ParameterValue=$DOMAIN \
               ParameterKey=HostedZoneId,ParameterValue=$ZONE_ID
aws cloudformation wait stack-create-complete --stack-name $ACM_STACK_NAME
aws cloudformation describe-stacks --stack-name $ACM_STACK_NAME


# create WebACL
MY_PUBLIC_IP="$(curl inet-ip.info)"; echo "MY_PUBLIC_IP=$MY_PUBLIC_IP"

aws cloudformation create-stack --region ap-northeast-1 --stack-name $WEBACL_STACK_NAME --template-body file://CFn/webacl.yaml \
  --parameters ParameterKey=AllowedIP1,ParameterValue=$MY_PUBLIC_IP
aws cloudformation wait stack-create-complete --stack-name $WEBACL_STACK_NAME
aws cloudformation describe-stacks --stack-name $WEBACL_STACK_NAME

# replace ingress placeholders
SED="docker run --rm -v $(pwd)/src:/opt/src -w /opt busybox:1.36 sed"

ACM_ARN=$(aws cloudformation describe-stacks --stack-name $ACM_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$ACM_STACK_NAME-acm'].OutputValue" --output text); echo "ACM_ARN=$ACM_ARN"
WEBACL_ARN=$(aws cloudformation describe-stacks --stack-name $WEBACL_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$WEBACL_STACK_NAME-webacl'].OutputValue" --output text); echo "WEBACL_ARN=$WEBACL_ARN"

$SED -i -e "s|^    alb.ingress.kubernetes.io/certificate-arn: .*$|    alb.ingress.kubernetes.io/certificate-arn: $ACM_ARN|g" src/pxr-ver-1.0/delivery/manifest/eks/ingress/pxr-ingress.yaml
$SED -i -e "s|^    alb.ingress.kubernetes.io/wafv2-acl-arn: .*$|    alb.ingress.kubernetes.io/wafv2-acl-arn: $WEBACL_ARN|g" src/pxr-ver-1.0/delivery/manifest/eks/ingress/pxr-ingress.yaml
$SED -i -e "/alb.ingress.kubernetes.io\/security-groups/d" src/pxr-ver-1.0/delivery/manifest/eks/ingress/pxr-ingress.yaml
$SED -i -e "s/domain.com/$DOMAIN/g" src/pxr-ver-1.0/delivery/manifest/eks/ingress/pxr-ingress.yaml

