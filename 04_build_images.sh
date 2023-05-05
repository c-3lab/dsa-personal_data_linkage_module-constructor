#!/bin/bash

source .env
echo "CERT_PREFECTURES=$CERT_PREFECTURES"
echo "CERT_MUNICIPALITIES=$CERT_MUNICIPALITIES"
echo "CERT_ORGANIZATION=$CERT_ORGANIZATION"

SED="docker run --rm -v $(pwd)/src:/opt/src busybox:1.36 sed"

# pxr-access-control-manage-service
mkdir -p ./src/pxr-access-control-manage-service/cert
cp ./cert/client.key ./src/pxr-access-control-manage-service/cert/
cp ./cert/client-ca.crt ./src/pxr-access-control-manage-service/cert/
cp ./cert/client-ca.crt ./src/pxr-access-control-manage-service/config/default-raw.crt
$SED -i -e '1d' /opt/src/pxr-access-control-manage-service/config/default-raw.crt
$SED -i -e '$d' /opt/src/pxr-access-control-manage-service/config/default-raw.crt
docker build -t pxr/pxr-access-control-manage-service:1.0 src/pxr-access-control-manage-service

# pxr-access-control-service
mkdir -p ./src/pxr-access-control-service/cert
cp ./cert/client.key ./src/pxr-access-control-service/cert/
cp ./cert/client-ca.crt ./src/pxr-access-control-service/cert/
docker build -t pxr/pxr-access-control-service:1.0 src/pxr-access-control-service

# pxr-binary-manage-service
docker build -t pxr/pxr-binary-manage-service:1.0 src/pxr-binary-manage-service

# pxr-block-proxy-service
docker build -t pxr/pxr-block-proxy-service:1.0 src/pxr-block-proxy-service

# pxr-book-manage-service
docker build -t pxr/pxr-book-manage-service:1.0 src/pxr-book-manage-service

# pxr-book-operate-service
docker build -t pxr/pxr-book-operate-service:1.0 src/pxr-book-operate-service

# pxr-catalog-service
docker build -t pxr/pxr-catalog-service:1.0 src/pxr-catalog-service

# pxr-catalog-update-service
docker build -t pxr/pxr-catalog-update-service:1.0 src/pxr-catalog-update-service

# pxr-certificate-manage-service
docker build -t pxr/pxr-certificate-manage-service:1.0 src/pxr-certificate-manage-service

# pxr-certification-authority-service
$SED -i -e "s/<prefectures>/$CERT_PREFECTURES/" /opt/src/pxr-certification-authority-service/Dockerfile
$SED -i -e "s/<municipalities>/$CERT_MUNICIPALITIES/" /opt/src/pxr-certification-authority-service/Dockerfile
$SED -i -e "s/<organization>/$CERT_ORGANIZATION/" /opt/src/pxr-certification-authority-service/Dockerfile
docker build -t pxr/pxr-certification-authority-service:1.0 src/pxr-certification-authority-service

# pxr-ctoken-ledger-service
docker build -t pxr/pxr-ctoken-ledger-service:1.0 src/pxr-ctoken-ledger-service

# pxr-identity-verificate-service
docker build -t pxr/pxr-identity-verificate-service:1.0 src/pxr-identity-verificate-service

# pxr-local-ctoken-service
docker build -t pxr/pxr-local-ctoken-service:1.0 src/pxr-local-ctoken-service

# pxr-notification-service
docker build -t pxr/pxr-notification-service:1.0 src/pxr-notification-service

# pxr-operator-service
docker build -t pxr/pxr-operator-service:1.0 src/pxr-operator-service

