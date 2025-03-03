#!/bin/bash

# Base URL (up to the part common to all files)
BASE_URL="https://raw.githubusercontent.com/pokt-network/pocket-network-genesis/refs/heads/master/shannon/testnet-beta"

# Array of filenames to download
FILES=("genesis.json" "app.toml" "client.toml" "config.toml")

# Loop through each file
for FILE_NAME in "${FILES[@]}"; do
  FILE_URL="$BASE_URL/$FILE_NAME"
  OUTPUT_FILE="$FILE_NAME"

  echo "Processing $OUTPUT_FILE..."

  # Check if the file already exists
  if [ ! -f "$OUTPUT_FILE" ]; then
    echo "$OUTPUT_FILE does not exist. Downloading from $FILE_URL..."
    curl -o "$OUTPUT_FILE" "$FILE_URL"

    # Check if the file was downloaded successfully
    if [ $? -eq 0 ]; then
      echo "File downloaded successfully: $OUTPUT_FILE"
    else
      echo "Failed to download the file from $FILE_URL"
      exit 1
    fi
  else
    echo "File $OUTPUT_FILE already exists. Skipping download."
  fi

done

# Set the desired namespace
NAMESPACE="${1:-shannon-beta}"

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NAMESPACE
EOF


# create genesis config map
kubectl delete --ignore-not-found --namespace=$NAMESPACE cm genesis
kubectl create cm genesis --from-file=./genesis.json --namespace=$NAMESPACE

kubectl delete --ignore-not-found --namespace=$NAMESPACE cm fullnode
kubectl create cm fullnode --from-file=./app.toml --from-file=./client.toml --from-file=./config.toml --namespace=$NAMESPACE

# create fullnode secrets
kubectl delete --ignore-not-found --namespace=$NAMESPACE secret fullnode
kubectl create secret generic fullnode --from-file=./node_key.json --from-file=./priv_validator_key.json --namespace=$NAMESPACE

helm install fullnode ../../charts/poktrolld \
  --namespace $NAMESPACE \
  --create-namespace \
  --values values.yaml
