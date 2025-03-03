#!/bin/bash

NAMESPACE="${1:-shannon-beta}"

kubectl delete --ignore-not-found --namespace=$NAMESPACE cm genesis
kubectl delete --ignore-not-found --namespace=$NAMESPACE cm fullnode
kubectl delete --ignore-not-found --namespace=$NAMESPACE secret fullnode
helm uninstall fullnode --namespace=$NAMESPACE --wait 2>/dev/null
