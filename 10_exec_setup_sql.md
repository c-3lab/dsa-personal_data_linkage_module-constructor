# start a psql container

```
utils/start_psql_pod.sh
```

# copy sql files to the started container (at another terminal)
```
kubectl --namespace pxr cp src/ddl/db pg:/opt
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
\i /opt/db/pxr-access-control-manage-service/createTable.sql
\i /opt/db/pxr-access-control-service/createTable.sql
\i /opt/db/pxr-binary-manage-service/createTable.sql
\i /opt/db/pxr-block-proxy-service/createTable.sql
\i /opt/db/pxr-book-manage-service/createTable.sql
\i /opt/db/pxr-book-operate-service/createTable.sql
\i /opt/db/pxr-catalog-service/createTable.sql
\i /opt/db/pxr-catalog-update-service/createTable.sql
\i /opt/db/pxr-certificate-manage-service/createTable.sql
\i /opt/db/pxr-certification-authority-service/createTable.sql
\i /opt/db/pxr-ctoken-ledger-service/createTable.sql
\i /opt/db/pxr-identity-verificate-service/createTable.sql
\i /opt/db/pxr-local-ctoken-service/createTable.sql
\i /opt/db/pxr-notification-service/createTable.sql
\i /opt/db/pxr-operator-service/createTable.sql
```
```
\q
```

