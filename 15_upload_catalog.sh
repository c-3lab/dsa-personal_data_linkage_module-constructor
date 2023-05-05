#!/bin/bash

source .env
echo "DOMAIN=$DOMAIN"

docker run --rm -v $(pwd)/src/pxr-ver-1.0/delivery/catalog:/opt/catalog -w /opt/catalog node:12-bullseye npm ci
docker run --rm -v $(pwd)/src/pxr-ver-1.0/delivery/catalog:/opt/catalog -w /opt/catalog node:12-bullseye node catalogRegister.js root.$DOMAIN

