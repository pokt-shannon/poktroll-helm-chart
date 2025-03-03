# Helm Chart for `poktrolld` with Snapshot Support

This repository contains the tools and configurations required to deploy and manage `poktrolld` (also referred to as Pocket Shannon) using a Helm chart. The primary focus of this project is to enhance the Helm chart to include **snapshot support** and provide an efficient way to test the deployment quickly.

---

## Repository Structure

- **`charts/poktrolld`**
  - This repository provides a Helm chart to streamline the deployment of the `poktrolld` service. It came from: https://github.com/pokt-network/helm-charts/tree/main/charts/poktrolld

- **`apps/fullnode`**
  - This directory contains the required values and scripts needed for configuring and deploying `poktrolld` as a full node using the Helm chart.
  - You can find the necessary values for setting up the deployment within this folder.

---

## Key Features

1. **Snapshot Support**  
   The Helm chart is extended to include options for managing and restoring **blockchain snapshots**, which allows quicker setup and recovery of the node.

2. **Quick Testing**  
   A simplified process has been included to allow developers and operators to quickly test their changes or deployments.

3. **Modular & Easy to Use**  
   The repository aims to make deploying and managing `poktrolld` as seamless as possible by leveraging Helm's modular architecture.

---

## Usage

### Prerequisites

- **Helm** must be installed on your machine. Follow the [Helm installation guide here](https://helm.sh/docs/intro/install/).
- Access to a Kubernetes cluster. Try [kind](https://kind.sigs.k8s.io/)!
- Knowledge of `poktrolld` deployment requirements. Read more about it in their [docs](https://dev.poktroll.com)

### Deployment

1. Navigate to the `apps/fullnode` directory.
2. Modify the `values.yaml` file to configure the node as needed.  
   For example, to enable **snapshot restoration**, update the respective keys in the file.
3. Run the following command to deploy the Helm chart:

   ```bash
   ./install.sh [namespace]
   ```

4. Verify that the deployment is running properly:

   ```bash
   kubectl get pods
   ```

5. Check the logs:

   ```bash
   # main process
   kubectl logs -f fullnode-poktrolld-0
   # snapshot download
   kubectl logs -f fullnode-poktrolld-0 -c get-snapshot
   # snapshot restore
   kubectl logs -f fullnode-poktrolld-0 -c load-snapshot
   ```
   
6. Monitor the sync process:

   ```bash
   watch -n 30 "kubectl exec fullnode-poktrolld-0 -c poktrolld -- poktrolld status | jq \".sync_info.latest_block_height\""  
   ```

7. To upgrade the release:

   ```bash
   ./upgrade.sh [namespace]
   ```

8. To uninstall the Helm chart, run the following command:

   ```bash
   ./uninstall.sh [namespace]
   ```

---

## Development Goals

This repository serves as a base for developers to:

1. Add snapshot-related functionality to the `poktrolld` Helm chart.
2. Improve deployment processes for faster testing and validation.
3. Ensure seamless integration of `poktrolld` with Kubernetes and Helm.

---

## Contributing

Contributions are welcome! If you'd like to contribute to this project, please submit a pull request or report any issues you encounter.

---

## TODO

1. [ ] Add key generation to avoid the need to generate one manually using `poktrolld init --home=./apps/fullnode fullnode`
2. [ ] Add a prune side-car (Research if we’re able to do it)
