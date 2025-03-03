#!/bin/bash

NAMESPACE="${1:-shannon-beta}"

# Upgrade release
helm upgrade fullnode ../../../../helm-charts/pokt-network/charts/poktrolld \
--namespace $NAMESPACE \
-f values.yaml

