#!/bin/bash

source .env
echo "RDS_STACK_NAME=$RDS_STACK_NAME"

echo "NAMESPACE=$NAMESPACE"

echo "DB_NAME=$DB_NAME"

echo "DOMAIN_NAME=$DOMAIN_NAME"
echo "EXT_NAME=$EXT_NAME"

echo "HASH_SALT=$HASH_SALT"
echo "HASH_STRETCH_COUNT=$HASH_STRETCH_COUNT"

SED="docker run --rm -v $(pwd)/src:/opt/src -w /opt busybox:1.36 sed"

DB_ENDPOINT=$(aws cloudformation describe-stacks --stack-name $RDS_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$RDS_STACK_NAME-endpoint-address'].OutputValue" --output text); echo "DB_ENDPOINT=$DB_ENDPOINT"
DB_USER_NAME=$(aws cloudformation describe-stacks --stack-name $RDS_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$RDS_STACK_NAME-db-username'].OutputValue" --output text); echo "DB_USER_NAME=$DB_USER_NAME"

SEARCH_ENDPOINT=$(aws cloudsearch describe-domains --query "DomainStatusList[?DomainName=='$DOMAIN_NAME'].SearchService.Endpoint" --output text);echo "SEARCH_ENDPOINT=$SEARCH_ENDPOINT"

ACCOUNTID=$(aws sts get-caller-identity --query "Account" --output text);echo "ACCOUNTID=$ACCOUNTID"

# replace placeholders
$SED -i -e "s/    \"ext_name\": \".*\"/    \"ext_name\": \"$EXT_NAME\"/g" /opt/src/catalog/society_catalog.json
find src/manifest/eks -name "*.yaml" | xargs $SED -i -e "s/<ext_name>/$EXT_NAME/g"
find src/manifest/eks -name "*.yaml" | xargs $SED -i -e "s/<cloudsearch-endpoint>/$SEARCH_ENDPOINT/g"
find src/manifest/eks -name "*.yaml" | xargs $SED -i -e "s/<password_hashsalt>/$HASH_SALT/g"
find src/manifest/eks -name "*.yaml" | xargs $SED -i -e "s/<password_hashStrechCount>/$HASH_STRETCH_COUNT/g"
find src/manifest/eks -name "*.yaml" | xargs $SED -i -e "s/<db_endpoint>/$DB_ENDPOINT/g"
find src/manifest/eks -name "*.yaml" | xargs $SED -i -e "s/<database_name>/$DB_NAME/g"
find src/manifest/eks -name "*.yaml" | xargs $SED -i -e "s/<user_name>/$DB_USER_NAME/g"
find src/manifest/eks -name "*.yaml" | xargs $SED -i -e "s/<password>/$DB_USER_PASSWORD/g"
find src/manifest/eks -name "*.yaml" | xargs $SED -i -e "s/<namespace>/$NAMESPACE/g"

$SED -i -e "/      - name: operator/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-operator-service:1.0/}" src/manifest/eks/deployment/application000001-deployment.yaml
$SED -i -e "/      - name: pxr-block-proxy/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-block-proxy-service:1.0/}" src/manifest/eks/deployment/application000001-deployment.yaml
$SED -i -e "/      - name: notification/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-notification-service:1.0/}" src/manifest/eks/deployment/application000001-deployment.yaml
$SED -i -e "/      - name: book-operate/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-book-operate-service:1.0/}" src/manifest/eks/deployment/application000001-deployment.yaml
$SED -i -e "/      - name: local-ctoken/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-local-ctoken-service:1.0/}" src/manifest/eks/deployment/application000001-deployment.yaml
$SED -i -e "/      - name: certificate-manage/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-certificate-manage-service:1.0/}" src/manifest/eks/deployment/application000001-deployment.yaml
$SED -i -e "/      - name: access-control/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-access-control-service:1.0/}" src/manifest/eks/deployment/application000001-deployment.yaml
$SED -i -e "/      - name: binary-manage/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-binary-manage-service:1.0/}" src/manifest/eks/deployment/application000001-deployment.yaml

$SED -i -e "/      - name: operator/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-operator-service:1.0/}" src/manifest/eks/deployment/region000001-deployment.yaml
$SED -i -e "/      - name: pxr-block-proxy/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-block-proxy-service:1.0/}" src/manifest/eks/deployment/region000001-deployment.yaml
$SED -i -e "/      - name: notification/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-notification-service:1.0/}" src/manifest/eks/deployment/region000001-deployment.yaml
$SED -i -e "/      - name: book-operate/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-book-operate-service:1.0/}" src/manifest/eks/deployment/region000001-deployment.yaml
$SED -i -e "/      - name: certificate-manage/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-certificate-manage-service:1.0/}" src/manifest/eks/deployment/region000001-deployment.yaml
$SED -i -e "/      - name: access-control/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-access-control-service:1.0/}" src/manifest/eks/deployment/region000001-deployment.yaml

$SED -i -e "/      - name: operator/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-operator-service:1.0/}" src/manifest/eks/deployment/root-deployment.yaml
$SED -i -e "/      - name: catalog/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-catalog-service:1.0/}" src/manifest/eks/deployment/root-deployment.yaml
$SED -i -e "/      - name: catalog-update/{n;s/        image: .*/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-catalog-update-service:1.0/}" src/manifest/eks/deployment/root-deployment.yaml
$SED -i -e "/      - name: pxr-block-proxy/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-block-proxy-service:1.0/}" src/manifest/eks/deployment/root-deployment.yaml
$SED -i -e "/      - name: notification/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-notification-service:1.0/}" src/manifest/eks/deployment/root-deployment.yaml
$SED -i -e "/      - name: book-manage/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-book-manage-service:1.0/}" src/manifest/eks/deployment/root-deployment.yaml
$SED -i -e "/      - name: identity-verificate/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-identity-verificate-service:1.0/}" src/manifest/eks/deployment/root-deployment.yaml
$SED -i -e "/      - name: ctoken-ledger/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-ctoken-ledger-service:1.0/}" src/manifest/eks/deployment/root-deployment.yaml
$SED -i -e "/      - name: certificate-authority/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-certification-authority-service:1.0/}" src/manifest/eks/deployment/root-deployment.yaml
$SED -i -e "/      - name: certificate-manage/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-certificate-manage-service:1.0/}" src/manifest/eks/deployment/root-deployment.yaml
$SED -i -e "/      - name: access-control/{n;s/        image: <ECRイメージURL:タグ>/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-access-control-service:1.0/}" src/manifest/eks/deployment/root-deployment.yaml
$SED -i -e "/      - name: access-control-manage/{n;s/        image: .*/        image: $ACCOUNTID.dkr.ecr.ap-northeast-1.amazonaws.com\/pxr-access-control-manage-service:1.0/}" src/manifest/eks/deployment/root-deployment.yaml

