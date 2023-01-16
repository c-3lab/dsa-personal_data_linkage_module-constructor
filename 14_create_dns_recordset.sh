#!/bin/bash

source .env

echo "DNS_STACK_NAME=$DNS_STACK_NAME"
echo "DOMAIN=$DOMAIN"
echo "NAMESPACE=$NAMESPACE"

ZONE_STR=$(aws route53 list-hosted-zones --query "HostedZones[?Name=='${DOMAIN}.'].Id" --output text)
SPLITTED=(${ZONE_STR//\// })
ZONE_ID=${SPLITTED[1]}; echo "ZONE_ID=$ZONE_ID"

ALB_HOST=$(kubectl -n $NAMESPACE get ingress pxr-ingress -o jsonpath='{.status.loadBalancer.ingress[].hostname}'); echo "ALB_HOST=$ALB_HOST"
ALB_ZONE_ID=$(aws elbv2 describe-load-balancers --query "LoadBalancers[?DNSName=='$ALB_HOST'].CanonicalHostedZoneId" --output text); echo "ALB_ZONE_ID=$ALB_ZONE_ID"

while :; do
  STATUS=$(aws elbv2 describe-load-balancers --query "LoadBalancers[?DNSName=='$ALB_HOST'].State.Code" --output text)
  echo "ALB STATUS=$STATUS"
  if [ "${STATUS:+foo}" ] && [ $STATUS == "active" ]; then
    break
  fi
  sleep 10
done

# create DNS A RecordSet
aws cloudformation create-stack --region ap-northeast-1 --stack-name $DNS_STACK_NAME --template-body file://CFn/dns.yaml \
  --parameters ParameterKey=DomainName,ParameterValue=$DOMAIN \
               ParameterKey=HostedZoneId,ParameterValue=$ZONE_ID \
               ParameterKey=ALBIngressHost,ParameterValue=$ALB_HOST \
               ParameterKey=ALBHostedZoneId,ParameterValue=$ALB_ZONE_ID
aws cloudformation wait stack-create-complete --stack-name $DNS_STACK_NAME
aws cloudformation describe-stacks --stack-name $DNS_STACK_NAME

while :; do
  STATUS_CODE=$(curl -sS https://root.$DOMAIN/ -o /dev/null -w '%{http_code}\n')
  echo "STATUS_CODE=$STATUS_CODE"
  if [ "${STATUS_CODE:+foo}" ] && [ $STATUS_CODE == "404" ]; then
    break
  fi
  sleep 10
done

