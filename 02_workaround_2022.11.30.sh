#!/bin/bash

SED="docker run --rm -v $(pwd)/src:/opt/src busybox:1.36 sed"

$SED -i -e "/^      serviceAccountName: region-root-block/d" /opt/src/manifest/eks/deployment/region000001-deployment.yaml
$SED -i -e "s/    DB_SCHEMA=pxr_certification_authority/    DB_SCHEMA=<database_name>/g" /opt/src/manifest/eks/configmap/root/certificate-authority-service-container.yaml
if [ ! -f src/pxr-certification-authority-service/starting.sh.back ]; then
  cp src/pxr-certification-authority-service/starting.sh src/pxr-certification-authority-service/starting.sh.back
  $SED -i -e "/^npm start;$/i cd /usr/src/app\ncron;" /opt/src/pxr-certification-authority-service/starting.sh
fi
if [ ! -f src/pxr-certification-authority-service/Dockerfile.back ]; then
  cp src/pxr-certification-authority-service/Dockerfile src/pxr-certification-authority-service/Dockerfile.back
  $SED -i -e "/RUN chmod +x \/usr\/src\/app\/starting.sh/a RUN chmod +x /usr/src/app/create-certificate-chain.bash" /opt/src/pxr-certification-authority-service/Dockerfile
fi
if [ ! -f src/catalog/catalogRegister.js.back ]; then
  cp src/catalog/catalogRegister.js src/catalog/catalogRegister.js.back
  $SED -i -e "65 s:^.*$:            return fs\.statSync\(file\)\.isFile\(\) \&\& /\.\*\\\.json\$/\.test\(file\) \&\& \! /package\\\-lock\\\.json/\.test\(file\) \&\& \! /package\\\.json/\.test\(file\);\r:g" /opt/src/catalog/catalogRegister.js
fi

