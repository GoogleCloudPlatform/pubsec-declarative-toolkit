# GCP PBMM Sandbox Environment

## What is Deployed in this package

- Private GKE Cluster
- Logging/Monitoring for GKE Cluster
  - Big Query Log Sink
  - GKE Metering

## Usage

0. Follow the steps in the [quickstart](../../README.md#Quickstart) to provision a config controller instances or the [advanced guide](../../docs/advanced-install.md) if you don't already have an instance up and running.

1. First make sure we have access to the target cluster and are pointing to the correct namespace. Bootstrap defaults for `CLUSTER` and `REGION` are:

- `CLUSTER=config-controller`
- `REGION=northamerica-northeast1`

```shell
gcloud anthos config controller get-credentials $CLUSTER  --location $REGION
kubens config-control
```

2. Fetch the package

```shell
kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/sandbox-gke sandbox-gke
```

3. Once we have done that we can start editing the `setters.yaml` file and populate the correct information. The values in the `setters` file will be used to populate the infrastructure YAML.

The following fields are exposed in `setters.yaml`

| Name | Default Value | Type |
| -------- | --------- | ----- |
| project-id | `sandbox-000000` | |
| project-namespace | `config-control` | |
| routing-mode | `REGIONAL` | |
| mtu | `1460` | |
| subnet-cidr | `10.2.0.0/16` | |
| log-aggregation-interval | `INTERVAL_5_SEC` | |
| flow-sampling | `0.5` | |
| log-metadata | `INCLUDE_ALL_METADATA | |
| private-google-access | `true` | |
| gke-services-cidr | `10.3.0.0/16` | |
| gke-pod-cidr | 10.4.0.0/16 | |
| gke-pod-range-name | clusterrange | |
| gke-services-range-name  | servicesrange | |
| location | northamerica-northeast1 | |
| cluster-description | dev-cluster | |
| cluster-name | sandbox  | |
| auth-network | | |
| tags | | |
| gke-admin | group@email.com | |
| gke-viewer | group@email.com | |
| machineType | e2-standard-4 | |
| region | northamerica-northeast1 | |

4. To populate the template with the `setters` inputs run `kpt fn render`.

5. Before we deploy the changes let's make sure we're in the correct `namespace` by running `kubens config-control`. Now we can run the `kpt` commands to deploy the configs to the Cluster.

```shell
kpt live init
kpt live apply
```

### Resources Provisions

| Resource | Namespace | Scope | Purpose |
| -------- | --------- | ----- | ------- |
| Artifact Registry | | | |
| Compute Firewall | | | |
| Compute Router | | | |
| Compute Router NAT | | | |
| Network | | | |
| Subnet | | | |
| GKE Cluster | | | |
| Container Node Pool | | | |
| Big Query Dataset | | | |
| Pub/Sub | | | |
| IAM Roles | | | |
