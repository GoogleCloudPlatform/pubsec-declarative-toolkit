# 30 Day Guardrails

## Description
sample description

## Usage


Create Project
```
gcloud projects create guardrails-controller --name="Guardrails Controller" --labels=type=infrastructure-automation --set-as-default
```

Enable Billing
```
gcloud beta billing projects link guardrails-controller --billing-account 0X0X0X-0X0X0X-0X0X0X
```
Create the Network
```
gcloud compute networks create default --subnet-mode=auto
```

Enable APIs
```
gcloud services enable krmapihosting.googleapis.com \
    container.googleapis.com \
    cloudresourcemanager.googleapis.com
```

Create Config Controller
```
gcloud anthos config controller create guardrails \
    --location=us-east1
```

Get access to the Controller
```
gcloud anthos config controller get-credentials guardrails \
    --location us-east1
```

Give Controller IAM Permissions to be able to create resources. You can get your org id by running the following commands `gcloud organizations list`
```
export PROJECT_ID=$(gcloud config get-value project)
export ORG_ID=0X0X0X-0X0X0X-0X0X0X
export SA_EMAIL="$(kubectl get ConfigConnectorContext -n config-control \
    -o jsonpath='{.items[0].spec.googleServiceAccount}' 2> /dev/null)"
gcloud organizations add-iam-policy-binding "${ORG_ID}" \
    --member "serviceAccount:${SA_EMAIL}" \
    --role "roles/resourcemanager.folderAdmin"
gcloud organizations add-iam-policy-binding "${ORG_ID}" \
    --member "serviceAccount:${SA_EMAIL}" \
    --role "roles/resourcemanager.projectCreator"
gcloud organizations add-iam-policy-binding "${ORG_ID}" \
    --member "serviceAccount:${SA_EMAIL}" \
    --role "roles/resourcemanager.projectDeleter"
gcloud organizations add-iam-policy-binding "${ORG_ID}" \
    --member "serviceAccount:${SA_EMAIL}" \
    --role "roles/iam.securityAdmin"
gcloud organizations add-iam-policy-binding "${ORG_ID}" \
    --member "serviceAccount:${SA_EMAIL}" \
    --role "roles/orgpolicy.policyAdmin"
```

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


### Fetch the package
`kpt pkg get GoogleCloudPlatform/gcp-pbmm-sandbox/gatekeeper-policies/solutions/guardrails.git guardrails`
Details: https://kpt.dev/reference/cli/pkg/get/

### View package content
`kpt pkg tree guardrails`
Details: https://kpt.dev/reference/cli/pkg/tree/

### Apply the package
```
kpt live init guardrails
kpt live apply guardrails --reconcile-timeout=2m --output=table
```
Details: https://kpt.dev/reference/cli/live/
