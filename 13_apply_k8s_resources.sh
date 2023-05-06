#!/bin/bash

source .env

# create a secret
cp cert/client-ca.crt cert/client.crt
kubectl -n $NAMESPACE create secret generic nginx-secret --from-file=cert/server.crt --from-file=cert/server.key --from-file=cert/client.crt --from-file=cert/client.key

# apply deployments
kubectl apply -f src/pxr-ver-1.0/delivery/manifest/eks/services -R
kubectl apply -f src/pxr-ver-1.0/delivery/manifest/eks/configmap -R
kubectl apply -f src/pxr-ver-1.0/delivery/manifest/eks/deployment/root-deployment.yaml
kubectl apply -f src/pxr-ver-1.0/delivery/manifest/eks/deployment/region000001-deployment.yaml
kubectl apply -f src/pxr-ver-1.0/delivery/manifest/eks/deployment/application000001-deployment.yaml
kubectl apply -f src/pxr-ver-1.0/delivery/manifest/eks/ingress/pxr-ingress.yaml

kubectl wait -n $NAMESPACE --timeout=600s --for=condition=available deployment/root-api
kubectl wait -n $NAMESPACE --timeout=600s --for=condition=available deployment/region000001-api
kubectl wait -n $NAMESPACE --timeout=600s --for=condition=available deployment/application000001-api

