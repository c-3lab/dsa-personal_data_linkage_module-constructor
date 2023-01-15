#!/bin/bash

source .env
echo "DOMAIN=$DOMAIN"

docker run --rm -v $(pwd)/src/catalog:/opt/catalog -w /opt/catalog node:12.22.12 npm ci
docker run --rm -v $(pwd)/src/catalog:/opt/catalog -w /opt/catalog node:12.22.12 node catalogRegister.js root.$DOMAIN

