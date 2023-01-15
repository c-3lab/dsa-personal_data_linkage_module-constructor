#!/bin/bash

source .env

# delete a secret
kubectl -n $NAMESPACE delete secret nginx-secret

# delete deployments
kubectl delete -f src/manifest/eks/ingress/pxr-ingress.yaml
kubectl delete -f src/manifest/eks/deployment/application000001-deployment.yaml
kubectl delete -f src/manifest/eks/deployment/region000001-deployment.yaml
kubectl delete -f src/manifest/eks/deployment/root-deployment.yaml
kubectl delete -f src/manifest/eks/configmap -R
kubectl delete -f src/manifest/eks/services -R

