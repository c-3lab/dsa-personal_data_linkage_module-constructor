#!/bin/bash

SED="docker run --rm -v $(pwd)/src:/opt/src busybox:1.36 sed"

if [ ! -f src/manifest/eks/deployment/region000001-deployment.yaml.back ]; then
  cp src/manifest/eks/deployment/region000001-deployment.yaml src/manifest/eks/deployment/region000001-deployment.yaml.back
  $SED -i -e "/^      serviceAccountName: region-root-block/d" /opt/src/manifest/eks/deployment/region000001-deployment.yaml
fi
if [ ! -f src/manifest/eks/configmap/root/certificate-authority-service-container.yaml.back ]; then
  cp src/manifest/eks/configmap/root/certificate-authority-service-container.yaml src/manifest/eks/configmap/root/certificate-authority-service-container.yaml.back
  $SED -i -e "s/    DB_SCHEMA=pxr_certification_authority/    DB_SCHEMA=<database_name>/g" /opt/src/manifest/eks/configmap/root/certificate-authority-service-container.yaml
fi
if [ ! -f src/manifest/eks/configmap/root/catalog-service-container.yaml.back ]; then
  cp src/manifest/eks/configmap/root/catalog-service-container.yaml src/manifest/eks/configmap/root/catalog-service-container.yaml.back
  $SED -i -e 's/            "database": "root_pod",/            "database": "<database_name>",/g' /opt/src/manifest/eks/configmap/root/catalog-service-container.yaml
fi
if [ ! -f src/pxr-certification-authority-service/starting.sh.back ]; then
  cp src/pxr-certification-authority-service/starting.sh src/pxr-certification-authority-service/starting.sh.back
  $SED -i -e "/^npm start;$/i cd /usr/src/app\ncron;" /opt/src/pxr-certification-authority-service/starting.sh
fi
if [ ! -f src/pxr-certification-authority-service/Dockerfile.back ]; then
  cp src/pxr-certification-authority-service/Dockerfile src/pxr-certification-authority-service/Dockerfile.back
  $SED -i -e "/RUN chmod +x \/usr\/src\/app\/starting.sh/a RUN chmod +x /usr/src/app/create-certificate-chain.bash" /opt/src/pxr-certification-authority-service/Dockerfile
fi
if [ ! -d src/catalog.back ]; then
  mv src/catalog src/catalog.back
  cp -rp workaround/catalog src/catalog
fi

