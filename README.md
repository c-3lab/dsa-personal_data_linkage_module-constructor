# dsa-personal\_data\_linkage\_module-constructor

This repository contains scripts and CFn Templates to build a personal data linkage platform of DSA onto AWS.

## CAUTION
**This repository supports the `2022/11/30 version` of the persional data linkage module.**

[パーソナルデータ連携モジュールソースコード(2022/11/30版)　［ZIP・6,324 KB］](https://data-society-alliance.org/wp-content/uploads/2022/11/%E3%83%91%E3%83%BC%E3%82%BD%E3%83%8A%E3%83%AB%E3%83%87%E3%83%BC%E3%82%BF%E9%80%A3%E6%90%BA%E3%83%A2%E3%82%B8%E3%83%A5%E3%83%BC%E3%83%AB_%E3%82%BD%E3%83%BC%E3%82%B9%E3%82%B3%E3%83%BC%E3%83%89.zip)

## How to use
### Preparation
1. Your domain must be managed on AWS Route53.
1. You should make docker available.
1. You should make the following tools available:
  * curl
  * openssl
  * aws cli (>2.9)
  * eksctl (>0.125)
  * kubectl (>1.25)

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

