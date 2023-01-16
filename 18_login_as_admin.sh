#!/bin/bash

source .env

echo "ADMIN_NAME=$ADMIN_NAME"
echo "HASH_SALT=$HASH_SALT"
echo "HASH_STRETCH_COUNT=$HASH_STRETCH_COUNT"

ADMIN_HPASS=$(docker run --rm -v $(pwd)/utils/hashed_password_generator:/opt -w /opt node:12.22.12 node hashed_password_generator.js $ADMIN_PASSWORD $HASH_SALT $HASH_STRETCH_COUNT);echo "ADMIN_HPASS=$ADMIN_HPASS"

# log in to the system as admin
curl -v -X POST "https://root.$DOMAIN/operator/operator/login" \
  -H "Accept: application/json" -H "Content-Type: application/json" \
  -d @- <<__EOS__
{
  "type": 3,
  "loginId": "$ADMIN_NAME",
  "hpassword": "$ADMIN_HPASS"
}
__EOS__

