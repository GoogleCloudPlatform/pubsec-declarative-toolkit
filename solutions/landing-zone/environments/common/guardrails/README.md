# 30 Day Guardrails

## Description
This packge contains the minimal set of infrastructure needed to help provision a 30 Day Guardrail Compliant Environment.

## Usage

0. Follow the steps in the [quickstart](../../README.md#Quickstart) to provision a config controller instances or the [advanced guide](../../docs/advanced-install.md)

1. Fetch the package
```
kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/guardrails guardrails
```

2. Edit the `setters.yaml` file with the values you need.

3. Apply the Changes
```
kpt live init guardrails --namespace config-control
kpt fn render
```

## Permissions

Permissions Needed For Config Controller SA
- Project Creator
- Folder Creator
- Billing User
- IAM
- Service Account Creator
- Policy Admin
- Logging

## Resources Provisioned

### Projects and Services

| Resource | Namespace | Scope | Purpose |
| -------- | --------- | ----- | ------- |
| Guardrails Project | Config Control | Org | |
| Guardrails Folder | Config Control | Org | |
| ConfigConnectorContext | Guardrails | Project | |
| Guardrails Service Account | Config Control | Project | |
| Guardrails Workload Identity IAM | Config Control | Project | |
| Guardrails Owner IAM | Config Control | Project | |
| Host Guardrails Owner IAM | Config Control | Project | |
| Org Policy Admin IAM | Config Control | Org | |
| Guardrails Policy Admin IAM | Guardrails | Org | |
| Org Logging Admin | Config Controller | Org | |
| Guardrails Logging Admin | Guardrails | Org | |
| Org Logging Config Writer | Config Controler | Org | |
| BigQuery Service | Guardrails | Project | |
| Cloud Scheduler | Guardrails | Project | |
| Cloud Build | Guardrails | Project | |

### Org Policies

| Resource | Namespace | Scope | Purpose |
| -------- | --------- | ----- | ------- |
| Restrict Resource Location Policy | Guardrails | Org | |
| disable-vpc-external-ipv6 Policy | Guardrails | Org | |
| require-shielded-vm Policy | Guardrails | Org ||
| require-trusted-images Policy | Guardrails | Org ||
| restrict-vm-external-access Policy | Guardrails | Org ||
| disable-serviceaccount-key-creation | Guardrails | Org ||
| restrict-vpc-peering Policy | Guardrails | Org ||
| uniform-bucket-level-access Policy | Guardrails | Org ||
| restrict-os-login Policy | Guardrails | Org ||
| restrict-loadbalancer-creation-types Policy | Guardrails | Org ||
| allowed-contact-domains Policy | Guardrails | Org ||
| allowed-policy-member-domain Policy | Guardrails | Org ||
| disable-serial-port-access Policy | Guardrails | Org ||
| vm-can-ip-forward Policy | Guardrails | Org ||
| disable-guest-attribute-access | Guardrails | Org ||
| disable-nested-virtualization | Guardrails | Org ||
| restrict-vpc-lien-removal | Guardrails | Org ||
| restrict-sql-public-ip | Guardrails | Org ||
| storage-public-access-prevention | Guardrails | Org ||

### Logging

| Resource | Namespace | Scope | Purpose |
| -------- | --------- | ----- | ------- |
| Storage Log Sink | Guardrails | Org ||
| Storage Bucket | Guardrails | Project ||
| PubSub Log Sink | Guardrails | Org ||
| PubSub Topic | Guardrails | Project ||
| BigQuery Log Sink | Guardrails | Org ||
| BigQuery Dataset | Guardrails | Project ||
| Org Audit Logs | Guardrails | Org ||
| BQ AUdit Data Viewer | Guardrails | Org ||
| BQ Audit Data User | Guardrails | Org ||
| BQ Billing Data User | Guardrails | Org ||
| BQ Billing Data Viewer | Guardrails | Org ||
| Billing Console Viewer | Guardrails | Org ||
| Asset Inventory Viewer | Guardrails | Org ||
| Cloud Build Trigger | Guardrails | Project ||
| Cloud Scheduler Job | Guadrails | Project ||
| Source Repository Service | Guardrails | Project ||
| Cloud Source Repository | Guardrails | Project ||

### View package content
`kpt pkg tree guardrails`
Details: https://kpt.dev/reference/cli/pkg/tree/

Details: https://kpt.dev/reference/cli/live/
