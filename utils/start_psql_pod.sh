#!/bin/bash

source $(cd $(dirname $0); pwd)/../.env

DB_USER_NAME=$(aws cloudformation describe-stacks --stack-name $RDS_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$RDS_STACK_NAME-db-username'].OutputValue" --output text); echo "DB_USER_NAME=$DB_USER_NAME"
DB_PORT=$(aws cloudformation describe-stacks --stack-name $RDS_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$RDS_STACK_NAME-db-port'].OutputValue" --output text); echo "DB_PORT=$DB_PORT"
DB_ENDPOINT=$(aws cloudformation describe-stacks --stack-name $RDS_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$RDS_STACK_NAME-endpoint-address'].OutputValue" --output text); echo "DB_ENDPOINT=$DB_ENDPOINT"

kubectl run --namespace pxr -it --rm --restart=Never --image=governmentpaas/psql --env="PGPASSWORD=$DB_USER_PASSWORD" pg -- psql -h $DB_ENDPOINT -p $DB_PORT -U $DB_USER_NAME -d $DB_NAME
