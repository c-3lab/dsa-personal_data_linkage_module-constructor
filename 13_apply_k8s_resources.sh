#!/bin/bash

# create a secret
cp cert/client-ca.crt cert/client.crt
kubectl -n pxr create secret generic nginx-secret --from-file=cert/server.crt --from-file=cert/server.key --from-file=cert/client.crt --from-file=cert/client.key

# apply deployments
kubectl apply -f src/manifest/eks/services -R
kubectl apply -f src/manifest/eks/configmap -R
kubectl apply -f src/manifest/eks/deployment/root-deployment.yaml
kubectl apply -f src/manifest/eks/deployment/region000001-deployment.yaml
kubectl apply -f src/manifest/eks/deployment/application000001-deployment.yaml
kubectl apply -f src/manifest/eks/ingress/pxr-ingress.yaml

