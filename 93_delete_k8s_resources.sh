#!/bin/bash

source .env

# delete a secret
kubectl -n $NAMESPACE delete secret nginx-secret

# delete deployments
kubectl delete -f src/pxr-ver-1.0/delivery/manifest/eks/ingress/pxr-ingress.yaml
kubectl delete -f src/pxr-ver-1.0/delivery/manifest/eks/deployment/application000001-deployment.yaml
kubectl delete -f src/pxr-ver-1.0/delivery/manifest/eks/deployment/region000001-deployment.yaml
kubectl delete -f src/pxr-ver-1.0/delivery/manifest/eks/deployment/root-deployment.yaml
kubectl delete -f src/pxr-ver-1.0/delivery/manifest/eks/configmap -R
kubectl delete -f src/pxr-ver-1.0/delivery/manifest/eks/services -R

