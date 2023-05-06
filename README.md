# dsa-personal\_data\_linkage\_module-constructor

This repository contains scripts and CFn Templates to build a personal data linkage platform of DSA onto AWS.

## Dependent Repositories
* [pxr-ver-1.0](https://github.com/Personal-Data-Linkage-Module/pxr-ver-1.0)
* [pxr-access-control-manage-service](https://github.com/Personal-Data-Linkage-Module/pxr-access-control-manage-service)
* [pxr-access-control-service](https://github.com/Personal-Data-Linkage-Module/pxr-access-control-service)
* [pxr-binary-manage-service](https://github.com/Personal-Data-Linkage-Module/pxr-binary-manage-service)
* [pxr-block-proxy-service](https://github.com/Personal-Data-Linkage-Module/pxr-block-proxy-service)
* [pxr-book-manage-service](https://github.com/Personal-Data-Linkage-Module/pxr-book-manage-service)
* [pxr-book-operate-service](https://github.com/Personal-Data-Linkage-Module/pxr-book-operate-service)
* [pxr-catalog-service](https://github.com/Personal-Data-Linkage-Module/pxr-catalog-service)
* [pxr-catalog-update-service](https://github.com/Personal-Data-Linkage-Module/pxr-catalog-update-service)
* [pxr-certificate-manage-service](https://github.com/Personal-Data-Linkage-Module/pxr-certificate-manage-service)
* [pxr-certification-authority-service](https://github.com/Personal-Data-Linkage-Module/pxr-certification-authority-service)
* [pxr-ctoken-ledger-service](https://github.com/Personal-Data-Linkage-Module/pxr-ctoken-ledger-service)
* [pxr-identity-verificate-service](https://github.com/Personal-Data-Linkage-Module/pxr-identity-verificate-service)
* [pxr-local-ctoken-service](https://github.com/Personal-Data-Linkage-Module/pxr-local-ctoken-service)
* [pxr-notification-service](https://github.com/Personal-Data-Linkage-Module/pxr-notification-service)
* [pxr-operator-service](https://github.com/Personal-Data-Linkage-Module/pxr-operator-service)

## How to use
### Preparation
1. Your domain must be managed on AWS Route53.
1. You should make docker available.
1. You should make the following tools available:
  * curl
  * openssl
  * aws cli (>2.11)
  * eksctl (>0.139)
  * kubectl (>1.25)
  * helm (>3.13)

### Construction
1. Copy `sample.env` to `.env` and edit its variables to fit your environment.
1. Apply the scripts (or markdown text) from `01_download_source.sh` to `17_exec_admin_sql.md` in order.

### Check
1. To verify that the system is constructed correctly, execute `18_login_as_admin.sh` and make sure that you can log into the system.

### Destruction
1. Apply the scripts from `92_delete_dns_recordset.sh` to `99_delete_ecr.sh` in order.

## Contributers

<a href="https://github.com/c-3lab/dsa-personal_data_linkage_module-constructor/graphs/contributors">
  <img src="https://contributors-img.web.app/image?repo=c-3lab/dsa-personal_data_linkage_module-constructor" />
</a>

Made with [contributors-img](https://contributors-img.web.app).

## LICENSE

[MIT LICENSE](./LICENSE)

