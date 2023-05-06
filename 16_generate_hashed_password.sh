#!/bin/bash

source .env

echo "ADMIN_NAME=$ADMIN_NAME"
echo "HASH_SALT=$HASH_SALT"
echo "HASH_STRETCH_COUNT=$HASH_STRETCH_COUNT"

# generate the Hashed password
ADMIN_HPASS=$(docker run --rm -v $(pwd)/utils/hashed_password_generator:/opt -w /opt node:12-bullseye node hashed_password_generator.js $ADMIN_PASSWORD $HASH_SALT $HASH_STRETCH_COUNT);echo "ADMIN_HPASS=$ADMIN_HPASS"

# generate insert_admin SQL
mkdir -p sql
cat << __EOF__ > ./sql/insert_admin.sql
INSERT INTO pxr_operator.operator
    (
        type, 
        login_id, 
        hpassword, 
        name, 
        auth, 
        password_changed_flg, 
        login_prohibited_flg, 
        attributes, 
        lock_flg, 
        is_disabled, 
        created_by, 
        updated_by, 
        unique_check_login_id
    )
VALUES
    (
        3, 
        '$ADMIN_NAME', 
        '$ADMIN_HPASS', 
        '$ADMIN_NAME', 
        '{"member":{"add":true,"update":true,"delete":true},"actor":{"application":true,"approval":true},"book":{"create":true},"catalog":{"create":true},"setting":{"update":true}}', 
        false, 
        false, 
        '{}', 
        false, 
        false, 
        'root_member001', 
        'root_member001', 
        'ADMIN013'
    );
__EOF__

