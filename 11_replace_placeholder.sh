#!/bin/bash

source .env

echo "RDS_STACK_NAME=$RDS_STACK_NAME"

echo "NAMESPACE=$NAMESPACE"

echo "DB_NAME=$DB_NAME"

echo "CLOUD_SEARCH_DOMAIN_NAME=$CLOUD_SEARCH_DOMAIN_NAME"
echo "EXT_NAME=$EXT_NAME"

echo "HASH_SALT=$HASH_SALT"
echo "HASH_STRETCH_COUNT=$HASH_STRETCH_COUNT"

SED="docker run --rm -v $(pwd)/src:/opt/src -w /opt busybox:1.36 sed"

DB_ENDPOINT=$(aws cloudformation describe-stacks --stack-name $RDS_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$RDS_STACK_NAME-endpoint-address'].OutputValue" --output text); echo "DB_ENDPOINT=$DB_ENDPOINT"
DB_USER_NAME=$(aws cloudformation describe-stacks --stack-name $RDS_STACK_NAME --query "Stacks[0].Outputs[?ExportName=='$RDS_STACK_NAME-db-username'].OutputValue" --output text); echo "DB_USER_NAME=$DB_USER_NAME"

SEARCH_ENDPOINT=$(aws cloudsearch describe-domains --query "DomainStatusList[?DomainName=='$CLOUD_SEARCH_DOMAIN_NAME'].SearchService.Endpoint" --output text);echo "SEARCH_ENDPOINT=$SEARCH_ENDPOINT"

ACCOUNTID=$(aws sts get-caller-identity --query "Account" --output text);echo "ACCOUNTID=$ACCOUNTID"

# replace placeholders in manifest
find src/manifest/eks -name "*.yaml" -print0 | xargs -0 $SED -i -e "s/<ext_name>/$EXT_NAME/g"
find src/manifest/eks -name "*.yaml" -print0 | xargs -0 $SED -i -e "s/<cloudsearch-endpoint>/$SEARCH_ENDPOINT/g"
find src/manifest/eks -name "*.yaml" -print0 | xargs -0 $SED -i -e "s/<password_hashsalt>/$HASH_SALT/g"
find src/manifest/eks -name "*.yaml" -print0 | xargs -0 $SED -i -e "s/<password_hashStrechCount>/$HASH_STRETCH_COUNT/g"
find src/manifest/eks -name "*.yaml" -print0 | xargs -0 $SED -i -e "s/<db_endpoint>/$DB_ENDPOINT/g"
find src/manifest/eks -name "*.yaml" -print0 | xargs -0 $SED -i -e "s/<database_name>/$DB_NAME/g"
find src/manifest/eks -name "*.yaml" -print0 | xargs -0 $SED -i -e "s/<user_name>/$DB_USER_NAME/g"
find src/manifest/eks -name "*.yaml" -print0 | xargs -0 $SED -i -e "s/<password>/$DB_USER_PASSWORD/g"
find src/manifest/eks -name "*.yaml" -print0 | xargs -0 $SED -i -e "s/<namespace>/$NAMESPACE/g"

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

# replace placeholders in catalog

PXR_ROOT_ACTOR_CODE="1000431"
if [ -d src/catalog/ext/\{ext_name\} ]; then
  mv src/catalog/ext/\{ext_name\} src/catalog/ext/$EXT_NAME
fi
if [ -d src/catalog/ext/pxrext/person/user-information/actor_\{pxr_root_actor_code\} ]; then
  mv src/catalog/ext/pxrext/person/user-information/actor_\{pxr_root_actor_code\} src/catalog/ext/pxrext/person/user-information/actor_$PXR_ROOT_ACTOR_CODE
fi
if [ -d src/catalog/ext/pxrext/setting/actor-own/pxr-root/actor_\{pxr_root_actor_code\} ]; then
  mv src/catalog/ext/pxrext/setting/actor-own/pxr-root/actor_\{pxr_root_actor_code\} src/catalog/ext/pxrext/setting/actor-own/pxr-root/actor_$PXR_ROOT_ACTOR_CODE
fi
if [ -d src/catalog/ext/pxrext/setting/actor/pxr-root/actor_\{pxr_root_actor_code\} ]; then
  mv src/catalog/ext/pxrext/setting/actor/pxr-root/actor_\{pxr_root_actor_code\} src/catalog/ext/pxrext/setting/actor/pxr-root/actor_$PXR_ROOT_ACTOR_CODE
fi

find src/catalog -type f -print0 | xargs -0 $SED -i -e "s/<ext_name>/$EXT_NAME/g"
find src/catalog -type f -print0 | xargs -0 $SED -i -e "s/<pxr_root_actor_code>/$PXR_ROOT_ACTOR_CODE/g"
find src/catalog -type f -print0 | xargs -0 $SED -i -e "s/<pxr_root_name>/流通制御サービスプロバイダー/g"
find src/catalog -type f -print0 | xargs -0 $SED -i -e "s/<global_setting_code>/1000374/g"
find src/catalog -type f -print0 | xargs -0 $SED -i -e "s/<pf_terms_code>/1000500/g"
find src/catalog -type f -print0 | xargs -0 $SED -i -e "s/<actor_setting_code>/1000731/g"
find src/catalog -type f -print0 | xargs -0 $SED -i -e "s/<actor_own_setting_code>/1000781/g"
find src/catalog -type f -print0 | xargs -0 $SED -i -e "s/<pxr_root_block_code>/1000401/g"
find src/catalog -type f -print0 | xargs -0 $SED -i -e "s/<person_item_type_address_code>/1000371/g"
find src/catalog -type f -print0 | xargs -0 $SED -i -e "s/<person_item_type_yob_code>/1000372/g"
find src/catalog -type f -print0 | xargs -0 $SED -i -e "s/<pxr_root_user_information_code>/1000373/g"

echo "CATALOG_DESC=$CATALOG_DESC"
$SED -i -e "s/<catalog_description>/$CATALOG_DESC/g" src/catalog/society_catalog.json

echo "CATALOG_PF_DESC_TITLE=$CATALOG_PF_DESC_TITLE"
echo "CATALOG_PF_DESC_SUBTITLE=$CATALOG_PF_DESC_SUBTITLE"
echo "CATALOG_PF_DESC_TEXT=$CATALOG_PF_DESC_TEXT"
echo "CATALOG_REGION_CERT_TITLE=$CATALOG_REGION_CERT_TITLE"
echo "CATALOG_REGION_CERT_TEXT=$CATALOG_REGION_CERT_TEXT"
echo "CATALOG_REGION_AUDIT_TITLE=$CATALOG_REGION_AUDIT_TITLE"
echo "CATALOG_REGION_AUDIT_TEXT=$CATALOG_REGION_AUDIT_TEXT"
echo "CATALOG_APP_CERT_TITLE=$CATALOG_APP_CERT_TITLE"
echo "CATALOG_APP_CERT_TEXT=$CATALOG_APP_CERT_TEXT"
echo "CATALOG_APP_AUDIT_TITLE=$CATALOG_APP_AUDIT_TITLE"
echo "CATALOG_APP_AUDIT_TEXT=$CATALOG_APP_AUDIT_TEXT"
echo "CATALOG_ORG_TITLE=$CATALOG_ORG_TITLE"
echo "CATALOG_ORG_SUBTITLE=$CATALOG_ORG_SUBTITLE"
echo "CATALOG_ORG_TEXT=$CATALOG_ORG_TEXT"
$SED -i -e "s/<pf_description_title>/$CATALOG_PF_DESC_TITLE/g" \
        -e "s/<pf_description_subtitle>/$CATALOG_PF_DESC_SUBTITLE/g" \
        -e "s/<pf_description_sentence>/$CATALOG_PF_DESC_TEXT/g" \
        -e "s/<region_certification_criteria_title>/$CATALOG_REGION_CERT_TITLE/g" \
        -e "s/<region_certification_criteria_sentence>/$CATALOG_REGION_CERT_TEXT/g" \
        -e "s/<region_audit_procedure_title>/$CATALOG_REGION_AUDIT_TITLE/g" \
        -e "s/<region_audit_procedure_sentence>/$CATALOG_REGION_AUDIT_TEXT/g" \
        -e "s/<app_certification_criteria_title>/$CATALOG_APP_CERT_TITLE/g" \
        -e "s/<app_certification_criteria_sentence>/$CATALOG_APP_CERT_TEXT/g" \
        -e "s/<app_audit_procedure_title>/$CATALOG_APP_AUDIT_TITLE/g" \
        -e "s/<app_audit_procedure_sentence>/$CATALOG_APP_AUDIT_TEXT/g" \
        -e "s/<organization_statement_title>/$CATALOG_ORG_TITLE/g" \
        -e "s/<organization_statement_subtitle>/$CATALOG_ORG_SUBTITLE/g" \
        -e "s/<organization_statement_sentence>/$CATALOG_ORG_TEXT/g" \
  src/catalog/ext/$EXT_NAME/actor/pxr-root/流通制御サービスプロバイダー_item.json

echo "DOMAIN=$DOMAIN"
$SED -i -e "s/<domain>/$DOMAIN/g" src/catalog/ext/$EXT_NAME/block/pxr-root/PXR-Root-Block_item.json

echo "ROOT_EMAIL_ADDRESS=$ROOT_EMAIL_ADDRESS"
echo "ROOT_TEL_NUMBER=$ROOT_TEL_NUMBER"
echo "ROOT_ADDRESS=$ROOT_ADDRESS"
echo "ROOT_INFO_SITE=$ROOT_INFO_SITE"
$SED -i -e "s/<email-address>/$ROOT_EMAIL_ADDRESS/g" \
        -e "s/<tel-number>/$ROOT_TEL_NUMBER/g" \
        -e "s/<address>/$ROOT_ADDRESS/g" \
        -e "s/<information-site>/$ROOT_INFO_SITE/g" \
  src/catalog/ext/$EXT_NAME/setting/actor-own/pxr-root/actor_$PXR_ROOT_ACTOR_CODE/setting_item.json

echo "SETTING_MANAGE_PASSWORD_SIMILARITY_CHECK=$SETTING_MANAGE_PASSWORD_SIMILARITY_CHECK"
echo "SETTING_PXR_ID_PREFIX=$SETTING_PXR_ID_PREFIX"
echo "SETTING_PXR_ID_SUFFIX=$SETTING_PXR_ID_SUFFIX"
echo "SETTING_PXR_ID_PASSWORD_SIMILARITY_CHECK=$SETTING_PXR_ID_PASSWORD_SIMILARITY_CHECK"
echo "SETTING_IDENTITY_VERIFICATION_EXPIRATION_TYPE=$SETTING_IDENTITY_VERIFICATION_EXPIRATION_TYPE"
echo "SETTING_IDENTITY_VERIFICATION_EXPIRATION_VAL=$SETTING_IDENTITY_VERIFICATION_EXPIRATION_VAL"
echo "SETTING_PASSWORD_EXPIRATION_TYPE=$SETTING_PASSWORD_EXPIRATION_TYPE"
echo "SETTING_PASSWORD_EXPIRATION_VAL=$SETTING_PASSWORD_EXPIRATION_VAL"
echo "SETTING_PASSWORD_GEN_NUM=$SETTING_PASSWORD_GEN_NUM"
echo "SETTING_SESSION_EXPIRATION_TYPE=$SETTING_SESSION_EXPIRATION_TYPE"
echo "SETTING_SESSION_EXPIRATION_VAL=$SETTING_SESSION_EXPIRATION_VAL"
echo "SETTING_ACCOUNT_LOCK_NUM=$SETTING_ACCOUNT_LOCK_NUM"
echo "SETTING_ACCOUNT_LOCK_RELEASE_TIEM_TYPE=$SETTING_ACCOUNT_LOCK_RELEASE_TIEM_TYPE"
echo "SETTING_ACCOUNT_LOCK_RELEASE_TIME_VAL=$SETTING_ACCOUNT_LOCK_RELEASE_TIME_VAL"
echo "SETTING_LOGIN_SMS_TEXT=$SETTING_LOGIN_SMS_TEXT"
echo "SETTING_BOOK_CREATE_SMS_TEXT=$SETTING_BOOK_CREATE_SMS_TEXT"
echo "SETTING_PERSONAL_DISASSOCIATION=$SETTING_PERSONAL_DISASSOCIATION"
echo "SETTING_PERSONAL_TWO_STEP_VERIFICATION=$SETTING_PERSONAL_TWO_STEP_VERIFICATION"
echo "SETTING_PERSONAL_SHARE_BASIC_POLICY=$SETTING_PERSONAL_SHARE_BASIC_POLICY"
echo "SETTING_PERSONAL_ACCOUNT_DELETE=$SETTING_PERSONAL_ACCOUNT_DELETE"
echo "SETTING_USE_APP_PROV=$SETTING_USE_APP_PROV"
echo "SETTING_USE_SHARE=$SETTING_USE_SHARE"
echo "SETTING_REGION_NOTIFICATION_INTERVAL_TYPE=$SETTING_REGION_NOTIFICATION_INTERVAL_TYPE"
echo "SETTING_REGION_NOTIFICATION_INTERVAL_VAL=$SETTING_REGION_NOTIFICATION_INTERVAL_VAL"
echo "SETTING_PF_NOTIFICATION_INTERVAL_TYPE=$SETTING_PF_NOTIFICATION_INTERVAL_TYPE"
echo "SETTING_PF_NOTIFICATION_INTERVAL_VAL=$SETTING_PF_NOTIFICATION_INTERVAL_VAL"
echo "SETTING_USE_REGION_SERVICE_OPERATION=$SETTING_USE_REGION_SERVICE_OPERATION"
echo "SETTING_MIN_PERIOD_PF_RECONSENT_TYPE=$SETTING_MIN_PERIOD_PF_RECONSENT_TYPE"
echo "SETTING_MIN_PERIOD_PF_RECONSENT_VAL=$SETTING_MIN_PERIOD_PF_RECONSENT_VAL"
echo "SETTING_MIN_PERIOD_REGION_RECONSENT_TYPE=$SETTING_MIN_PERIOD_REGION_RECONSENT_TYPE"
echo "SETTING_MIN_PERIOD_REGION_RECONSENT_VAL=$SETTING_MIN_PERIOD_REGION_RECONSENT_VAL"
echo "SETTING_BOOK_DELETION_PENDING_TERM_TYPE=$SETTING_BOOK_DELETION_PENDING_TERM_TYPE"
echo "SETTING_BOOK_DELETION_PENDING_TERM_VAL=$SETTING_BOOK_DELETION_PENDING_TERM_VAL"
echo "SETTING_DATA_DOWNLOAD_TERM_EXPIRATION_TYPE=$SETTING_DATA_DOWNLOAD_TERM_EXPIRATION_TYPE"
echo "SETTING_DATA_DOWNLOAD_TERM_EXPIRATION_VAL=$SETTING_DATA_DOWNLOAD_TERM_EXPIRATION_VAL"
$SED -i -e "s/<management_password_similarity_check>/$SETTING_MANAGE_PASSWORD_SIMILARITY_CHECK/g" \
        -e "s/<pxr_id_prefix>/$SETTING_PXR_ID_PREFIX/g" \
        -e "s/<pxr_id_suffix>/$SETTING_PXR_ID_SUFFIX/g" \
        -e "s/<pxr_id_password_similarity_check>/$SETTING_PXR_ID_PASSWORD_SIMILARITY_CHECK/g" \
        -e "s/<identity-verification-expiration_type>/$SETTING_IDENTITY_VERIFICATION_EXPIRATION_TYPE/g" \
        -e "s/<identity-verification-expiration_value>/$SETTING_IDENTITY_VERIFICATION_EXPIRATION_VAL/g" \
        -e "s/<password-expiration_type>/$SETTING_PASSWORD_EXPIRATION_TYPE/g" \
        -e "s/<password-expiration_value>/$SETTING_PASSWORD_EXPIRATION_VAL/g" \
        -e "s/<password-generations-number>/$SETTING_PASSWORD_GEN_NUM/g" \
        -e "s/<session-expiration_type>/$SETTING_SESSION_EXPIRATION_TYPE/g" \
        -e "s/<session-expiration_value>/$SETTING_SESSION_EXPIRATION_VAL/g" \
        -e "s/<account-lock-count>/$SETTING_ACCOUNT_LOCK_NUM/g" \
        -e "s/<account-lock-release-time_type>/$SETTING_ACCOUNT_LOCK_RELEASE_TIEM_TYPE/g" \
        -e "s/<account-lock-release-time_value>/$SETTING_ACCOUNT_LOCK_RELEASE_TIME_VAL/g" \
        -e "s/<login_sms_message>/$SETTING_LOGIN_SMS_TEXT/g" \
        -e "s/<book_create_sms_message>/$SETTING_BOOK_CREATE_SMS_TEXT/g" \
        -e "s/<personal_disassociation>/$SETTING_PERSONAL_DISASSOCIATION/g" \
        -e "s/<personal_two-step_verification>/$SETTING_PERSONAL_TWO_STEP_VERIFICATION/g" \
        -e "s/<personal_share_basic_policy>/$SETTING_PERSONAL_SHARE_BASIC_POLICY/g" \
        -e "s/<personal_account_delete>/$SETTING_PERSONAL_ACCOUNT_DELETE/g" \
        -e "s/<use_app-p>/$SETTING_USE_APP_PROV/g" \
        -e "s/<use_share>/$SETTING_USE_SHARE/g" \
        -e "s/<region-tou_re-consent_notification_interval_type>/$SETTING_REGION_NOTIFICATION_INTERVAL_TYPE/g" \
        -e "s/<region-tou_re-consent_notification_interval_value>/$SETTING_REGION_NOTIFICATION_INTERVAL_VAL/g" \
        -e "s/<platform-tou_re-consent_notification_interval_type>/$SETTING_PF_NOTIFICATION_INTERVAL_TYPE/g" \
        -e "s/<platform-tou_re-consent_notification_interval_value>/$SETTING_PF_NOTIFICATION_INTERVAL_VAL/g" \
        -e "s/<use_region_service_operation>/$SETTING_USE_REGION_SERVICE_OPERATION/g" \
        -e "s/<min_period_for_platform-tou_re-consent_type>/$SETTING_MIN_PERIOD_PF_RECONSENT_TYPE/g" \
        -e "s/<min_period_for_platform-tou_re-consent_value>/$SETTING_MIN_PERIOD_PF_RECONSENT_VAL/g" \
        -e "s/<min_period_for_region-tou_re-consent_type>/$SETTING_MIN_PERIOD_REGION_RECONSENT_TYPE/g" \
        -e "s/<min_period_for_region-tou_re-consent_value>/$SETTING_MIN_PERIOD_REGION_RECONSENT_VAL/g" \
        -e "s/<book_deletion_pending_term_type>/$SETTING_BOOK_DELETION_PENDING_TERM_TYPE/g" \
        -e "s/<book_deletion_pending_term_value>/$SETTING_BOOK_DELETION_PENDING_TERM_VAL/g" \
        -e "s/<data_download_term_expiration_type>/$SETTING_DATA_DOWNLOAD_TERM_EXPIRATION_TYPE/g" \
        -e "s/<data_download_term_expiration_value>/$SETTING_DATA_DOWNLOAD_TERM_EXPIRATION_VAL/g" \
  src/catalog/ext/$EXT_NAME/setting/global/setting_item.json

echo "SETTING_PF_TERMS_TITLE=$SETTING_PF_TERMS_TITLE"
echo "SETTING_PF_TERMS_SUBTITLE=$SETTING_PF_TERMS_SUBTITLE"
echo "SETTING_PF_TERMS_TEXT=$SETTING_PF_TERMS_TEXT"
echo "SETTING_RECONSENT_FLAG=$SETTING_RECONSENT_FLAG"
echo "SETTING_PERIOD_RECONSENT=$SETTING_PERIOD_RECONSENT"
echo "SETTING_DELETING_DATA_FLAG=$SETTING_DELETING_DATA_FLAG"
echo "SETTING_RETURNING_DATA_FLAG=$SETTING_RETURNING_DATA_FLAG"
$SED -i -e "s/<pf_terms_title>/$SETTING_PF_TERMS_TITLE/g" \
        -e "s/<pf_terms_subtitle>/$SETTING_PF_TERMS_SUBTITLE/g" \
        -e "s/<pf_terms_sentence>/$SETTING_PF_TERMS_TEXT/g" \
        -e "s/<re-consent-flag>/$SETTING_RECONSENT_FLAG/g" \
        -e "s/<period-of-re-consent>/$SETTING_PERIOD_RECONSENT/g" \
        -e "s/<deleting-data-flag>/$SETTING_DELETING_DATA_FLAG/g" \
        -e "s/<returning-data-flag>/$SETTING_RETURNING_DATA_FLAG/g" \
  src/catalog/ext/$EXT_NAME/terms-of-use/platform/pf-terms-of-use_item.json

