# start a psql container

```
utils/start_psql_pod.sh
```

# copy sql files to the started container (at another terminal)
```
source .env
kubectl --namespace $NAMESPACE cp src/pxr-ver-1.0/database pg:/opt
```

# execute below commands
```
CREATE USER pxr_access_control_user WITH PASSWORD 'pxr_password';
CREATE USER pxr_access_manage_user WITH PASSWORD 'pxr_password';
CREATE USER pxr_book_manage_user WITH PASSWORD 'pxr_password';
CREATE USER pxr_binary_manage_user WITH PASSWORD 'pxr_password';
CREATE USER pxr_book_operate_user WITH PASSWORD 'pxr_password';
CREATE USER pxr_catalog_user WITH PASSWORD 'pxr_password';
CREATE USER pxr_catalog_update_user WITH PASSWORD 'pxr_password';
CREATE USER pxr_certification_authority_user WITH PASSWORD 'pxr_password';
CREATE USER pxr_certificate_manage_user WITH PASSWORD 'pxr_password';
CREATE USER pxr_identify_verify_user WITH PASSWORD 'pxr_password';
CREATE USER pxr_notification_user WITH PASSWORD 'pxr_password';
CREATE USER pxr_operator_user WITH PASSWORD 'pxr_password';
CREATE USER pxr_block_proxy_user WITH PASSWORD 'pxr_password';
CREATE USER pxr_ctoken_ledger_user WITH PASSWORD 'pxr_password';
CREATE USER pxr_local_ctoken_user WITH PASSWORD 'pxr_password';
```
```
GRANT pxr_access_control_user TO postgres;
GRANT pxr_access_manage_user TO postgres ;
GRANT pxr_book_manage_user TO postgres ;
GRANT pxr_binary_manage_user TO postgres ;
GRANT pxr_book_operate_user TO postgres ;
GRANT pxr_catalog_user TO postgres ;
GRANT pxr_catalog_update_user TO postgres ;
GRANT pxr_certification_authority_user TO postgres ;
GRANT pxr_certificate_manage_user TO postgres ;
GRANT pxr_identify_verify_user TO postgres ;
GRANT pxr_notification_user TO postgres ;
GRANT pxr_operator_user TO postgres ;
GRANT pxr_block_proxy_user TO postgres ;
GRANT pxr_ctoken_ledger_user TO postgres ;
GRANT pxr_local_ctoken_user TO postgres ;
```
```
CREATE SCHEMA pxr_access_control AUTHORIZATION pxr_access_control_user;
CREATE SCHEMA pxr_access_manage AUTHORIZATION pxr_access_manage_user;
CREATE SCHEMA pxr_binary_manage AUTHORIZATION pxr_binary_manage_user;
CREATE SCHEMA pxr_book_manage AUTHORIZATION pxr_book_manage_user;
CREATE SCHEMA pxr_book_operate AUTHORIZATION pxr_book_operate_user;
CREATE SCHEMA pxr_catalog AUTHORIZATION pxr_catalog_user;
CREATE SCHEMA pxr_catalog_update AUTHORIZATION pxr_catalog_update_user;
CREATE SCHEMA pxr_certification_authority AUTHORIZATION pxr_certification_authority_user;
CREATE SCHEMA pxr_certificate_manage AUTHORIZATION pxr_certificate_manage_user;
CREATE SCHEMA pxr_identify_verify AUTHORIZATION pxr_identify_verify_user;
CREATE SCHEMA pxr_notification AUTHORIZATION pxr_notification_user;
CREATE SCHEMA pxr_operator AUTHORIZATION pxr_operator_user;
CREATE SCHEMA pxr_block_proxy AUTHORIZATION pxr_block_proxy_user;
CREATE SCHEMA pxr_ctoken_ledger AUTHORIZATION pxr_ctoken_ledger_user;
CREATE SCHEMA pxr_local_ctoken AUTHORIZATION pxr_local_ctoken_user;
```
```
\i /opt/database/pxr-access-control-manage-service/createTable.sql
\i /opt/database/pxr-access-control-service/createTable.sql
\i /opt/database/pxr-binary-manage-service/createTable.sql
\i /opt/database/pxr-block-proxy-service/createTable.sql
\i /opt/database/pxr-book-manage-service/createTable.sql
\i /opt/database/pxr-book-operate-service/createTable.sql
\i /opt/database/pxr-catalog-service/createTable.sql
\i /opt/database/pxr-catalog-update-service/createTable.sql
\i /opt/database/pxr-certificate-manage-service/createTable.sql
\i /opt/database/pxr-certification-authority-service/createTable.sql
\i /opt/database/pxr-ctoken-ledger-service/createTable.sql
\i /opt/database/pxr-identity-verificate-service/createTable.sql
\i /opt/database/pxr-local-ctoken-service/createTable.sql
\i /opt/database/pxr-notification-service/createTable.sql
\i /opt/database/pxr-operator-service/createTable.sql
```
```
GRANT ALL PRIVILEGES ON pxr_access_manage.token_generation_history TO pxr_access_manage_user;
GRANT ALL PRIVILEGES ON pxr_access_manage.token_access_history TO pxr_access_manage_user;
GRANT ALL PRIVILEGES ON pxr_access_manage.caller_role TO pxr_access_manage_user;
GRANT ALL PRIVILEGES ON pxr_access_manage.token_generation_history_id_seq TO pxr_access_manage_user;
GRANT ALL PRIVILEGES ON pxr_access_manage.token_access_history_id_seq TO pxr_access_manage_user;
GRANT ALL PRIVILEGES ON pxr_access_manage.caller_role_id_seq TO pxr_access_manage_user;
GRANT ALL PRIVILEGES ON pxr_access_control.api_access_permission TO pxr_access_control_user;
GRANT ALL PRIVILEGES ON pxr_access_control.caller_role TO pxr_access_control_user;
GRANT ALL PRIVILEGES ON pxr_access_control.api_token TO pxr_access_control_user;
GRANT ALL PRIVILEGES ON pxr_access_control.api_access_permission_id_seq TO pxr_access_control_user;
GRANT ALL PRIVILEGES ON pxr_access_control.api_token_id_seq TO pxr_access_control_user;
GRANT ALL PRIVILEGES ON pxr_access_control.caller_role_id_seq TO pxr_access_control_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA pxr_binary_manage TO pxr_binary_manage_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA pxr_binary_manage TO pxr_binary_manage_user;
GRANT ALL PRIVILEGES ON pxr_block_proxy.log_called_api TO pxr_block_proxy_user;
GRANT ALL PRIVILEGES ON pxr_block_proxy.log_called_api_id_seq TO pxr_block_proxy_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA pxr_book_manage TO pxr_book_manage_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA pxr_book_manage TO pxr_book_manage_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA pxr_book_operate TO pxr_book_operate_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA pxr_book_operate TO pxr_book_operate_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA pxr_catalog TO pxr_catalog_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA pxr_catalog TO pxr_catalog_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA pxr_catalog_update TO pxr_catalog_update_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA pxr_catalog_update TO pxr_catalog_update_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA pxr_certificate_manage TO pxr_certificate_manage_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA pxr_certificate_manage TO pxr_certificate_manage_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA pxr_certification_authority TO pxr_certification_authority_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA pxr_certification_authority TO pxr_certification_authority_user;
GRANT ALL PRIVILEGES ON pxr_ctoken_ledger.ctoken TO pxr_ctoken_ledger_user;
GRANT ALL PRIVILEGES ON pxr_ctoken_ledger.ctoken_id_seq TO pxr_ctoken_ledger_user;
GRANT ALL PRIVILEGES ON pxr_ctoken_ledger.ctoken_history TO pxr_ctoken_ledger_user;
GRANT ALL PRIVILEGES ON pxr_ctoken_ledger.ctoken_history_id_seq TO pxr_ctoken_ledger_user;
GRANT ALL PRIVILEGES ON pxr_ctoken_ledger.cmatrix TO pxr_ctoken_ledger_user;
GRANT ALL PRIVILEGES ON pxr_ctoken_ledger.cmatrix_id_seq TO pxr_ctoken_ledger_user;
GRANT ALL PRIVILEGES ON pxr_ctoken_ledger.row_hash TO pxr_ctoken_ledger_user;
GRANT ALL PRIVILEGES ON pxr_ctoken_ledger.row_hash_id_seq TO pxr_ctoken_ledger_user;
GRANT ALL PRIVILEGES ON pxr_ctoken_ledger.document TO pxr_ctoken_ledger_user;
GRANT ALL PRIVILEGES ON pxr_ctoken_ledger.document_id_seq TO pxr_ctoken_ledger_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA pxr_identify_verify TO pxr_identify_verify_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA pxr_identify_verify TO pxr_identify_verify_user;
GRANT ALL PRIVILEGES ON pxr_local_ctoken.row_hash TO pxr_local_ctoken_user;
GRANT ALL PRIVILEGES ON pxr_local_ctoken.row_hash_id_seq TO pxr_local_ctoken_user;
GRANT ALL PRIVILEGES ON pxr_local_ctoken.document TO pxr_local_ctoken_user;
GRANT ALL PRIVILEGES ON pxr_local_ctoken.document_id_seq TO pxr_local_ctoken_user;
GRANT ALL PRIVILEGES ON pxr_notification.notification TO pxr_notification_user;
GRANT ALL PRIVILEGES ON pxr_notification.notification_destination TO pxr_notification_user;
GRANT ALL PRIVILEGES ON pxr_notification.readflag_management TO pxr_notification_user;
GRANT ALL PRIVILEGES ON pxr_notification.approval_managed TO pxr_notification_user;
GRANT ALL PRIVILEGES ON pxr_notification.notification_id_seq TO pxr_notification_user;
GRANT ALL PRIVILEGES ON pxr_notification.notification_destination_id_seq TO pxr_notification_user;
GRANT ALL PRIVILEGES ON pxr_notification.readflag_management_id_seq TO pxr_notification_user;
GRANT ALL PRIVILEGES ON pxr_notification.approval_managed_id_seq TO pxr_notification_user;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA pxr_operator TO pxr_operator_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA pxr_operator TO pxr_operator_user;
```
```
\q
```

