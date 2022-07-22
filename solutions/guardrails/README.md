# 30 Day Guardrails

## Description
This packge contains the minimal set of infrastructure needed to help provision a 30 Day Guardrail Compliant Environment.

## Usage

0. Follow the steps in the [quickstart](../../README.md#Quickstart) to provision a config controller instances or the [advanced guide](../../docs/advanced-install.md)

    Once you have a config controller instance up and running you can proceed with the next steps.

    The following permissions are required on the service account being used.

    ## Permissions

    The following permissions Needed For Config Controller SA
    - Project Creator
    - Folder Creator
    - Billing User
    - IAM
    - Service Account Creator
    - Policy Admin
    - Logging

    They can be set by running the following commands:
    ```
    export ORG_ID=your-org-id
    export SA_EMAIL="$(kubectl get ConfigConnectorContext -n config-control -o jsonpath='{.items[0].spec.googleServiceAccount}' 2> /dev/null)"

    gcloud organizations add-iam-policy-binding "${ORG_ID}" --member 
    "serviceAccount:${SA_EMAIL}" --role "roles/resourcemanager.projectCreator"
    gcloud organizations add-iam-policy-binding "${ORG_ID}" --member "serviceAccount:${SA_EMAIL}" --role "roles/resourcemanager.projectDeleter"
    gcloud organizations add-iam-policy-binding "${ORG_ID}" --member "serviceAccount:${SA_EMAIL}" --role "roles/resourcemanager.folderAdmin"
    gcloud organizations add-iam-policy-binding "${ORG_ID}" --member "serviceAccount:${SA_EMAIL}" --role "roles/billing.user"
    gcloud organizations add-iam-policy-binding "${ORG_ID}" --member "serviceAccount:${SA_EMAIL}" --role "roles/iam.securityAdmin"
    gcloud organizations add-iam-policy-binding "${ORG_ID}" --member "serviceAccount:${SA_EMAIL}" --role roles/iam.serviceAccountAdmin
    gcloud organizations add-iam-policy-binding "${ORG_ID}" --member "serviceAccount:${SA_EMAIL}" --role "roles/orgpolicy.policyAdmin"
    gcloud organizations add-iam-policy-binding "${ORG_ID}" --member "serviceAccount:${SA_EMAIL}" --role "roles/serviceusage.serviceUsageConsumer"
    gcloud organizations add-iam-policy-binding "${ORG_ID}" --member "serviceAccount:${SA_EMAIL}" --role roles/logging.admin
    ```

1. Fetch the `guardrails` package by running the `kpt pkg get` command.

```
kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/guardrails guardrails
```

This will download the package containing the configuration files for the Guardrails deployment.

2. Set Organization Hierarchy (optional)

    Modifiy `configs/hierarchy/hiearchy.yaml` if required. The default settings will create a single folder called  `guardrails` and the guardrails project will be deployed into that.

3. Customize the Guardrails Package.

    Edit `setters.yaml` with the relevant information. 

    Emails used for groups should be exist in iam/groups before running the script.

    Project Number and Project ID for the management project will be for the project that the config controller instance runs in.  

    The following values are exposed in the `setters.yaml` file. Additional changes can be made by modifying the packages yaml files.

    | Name | Default | Description |
    | --- | --- | --- |
    | billing-id | "0000000000" | Billing ID used with created projects |
    | org-id | "0000000000" | Target Organization ID |
    | management-project-id | management-project-12345  | ID of the Project where the Config Controller instance is located |
    | management-project-number | "0000000000" |  Number of the Project where the Config Controller instance is location |
    | management-namespace | "config-controller" |  Number of the Project where the Config Controller instance is location |
    | guardrails-project-id | guardrails-project-12345 | ID to be used for the Guardrails Project |
    | guardrails-namespace | config-controller | ID to be used for the Guardrails Project |
    | audit-viewer-group | group@domain.com | Group email to get audit viewer permissions |
    | audit-data-group | group@domain.com | Group email to get log writer permissions |
    | audit-data-viewer-group | group@domain.com | Group email to get audit data viewer permissions for the bq billing exports |
    | billing-data-viewer-group | group@domain.com | Group email to get billing data viewer permissions for the bq billing exports |
    | billing-console-viewer-group | group@domain.com | Group email to get billing viewer permissions |

4. Apply the Changes

The following commands will set the values from `setters.yaml`, generate the hierarchy and service configs.

```
kpt live init guardrails --namespace config-control
kpt fn render
```

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
