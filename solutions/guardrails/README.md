# 30 Day Guardrails

## Description

This package contains the minimal set of infrastructure needed to help provision a 30 Day Guardrail Compliant Environment.

## Usage

1. Create a Config Controller instance with the `arete` cli tool. Installation instructions [here](../../cli/README.md)

    First we will ensure the default logging buckets that are generated with a new project are set to the selected region instead of the default location `global` with the following command.

    ```shell
    export REGION=northamerica-northeast1
    export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
    export ORG_ID=$(gcloud projects get-ancestors $PROJECT_ID --format='get(id)' | tail -1)
    export EMAIL=$(gcloud config list --format json|jq .core.account | sed 's/"//g')
    gcloud organizations add-iam-policy-binding "${ORG_ID}" --member "user:${EMAIL}" --role roles/logging.admin
    gcloud alpha logging settings update --organization=$ORG_ID --storage-location=$REGION
    ```

    Now we can run the `arete` command to create the environment.

    `arete create my-awesome-kcc --region=northamerica-northeast1 --project=target-project`

    This takes about 20 minutes to provision.

    Once you have a config controller instance up and running you can proceed with the next steps.

    Alternatively you can follow the steps in the [quickstart](../../README.md#Quickstart) or the [advanced guide](../../docs/advanced-install.md).

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

 ```shell
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

2. Fetch the `guardrails` package by running the `kpt pkg get` command.

```shell
kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/guardrails@v0.0.2-alpha guardrails
```

This will download the package containing the configuration files for the Guardrails deployment.

3. Set Organization Hierarchy (optional)

    Modifiy `configs/hierarchy/hierarchy.yaml` if required. The default settings will create a single folder called  `guardrails` and the guardrails project will be deployed into that.

    When the solution is deployed you should have a folder at the top level with a guardrails project under it.

    ```yaml
    Org Root
    - guardrails folder
        - guardrails project
    ```

4. Customize the Guardrails Package.

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
    | management-namespace | "config-control" |  Location of installed common resources. Modify if doing multi-tenancy. |
    | guardrails-project-id | guardrails-project-12345 | ID to be used for the Guardrails Project. Must be globally unique. |
    | guardrails-namespace | "config-control" | Location of installed guardrails resources. Modify if doing multi-tenancy. |
    | asset-viewer-group | group@domain.com | Group email to get asset inventory viewer permissions |
    | audit-data-group | group@domain.com | Group email to get audit data viewer permissions for the logging data in BQ |
    | audit-data-viewer-group | group@domain.com | Group email to get audit data user permissions for the the logging data in BQ |
    | billing-data-viewer-group | group@domain.com | Group email to get billing data viewer permissions for the bq billing exports |
    | billing-data-group | group@domain.com | Group email to get billing data user permissions for the bq billing exports |
    | billing-console-viewer-group | group@domain.com | Group email to get billing viewer permissions |

5. Apply the Changes

The following commands will set the values from `setters.yaml`, generate the hierarchy and service configs.

```shell
kpt live init guardrails --namespace config-control
kpt fn render
```

6. Deploy the Solution.

```shell
kpt live apply
```

You should get output that matches the following

```plaintext
installing inventory ResourceGroup CRD.
inventory update started
inventory update finished
apply phase started
namespace/guardrails apply successful
rolebinding.rbac.authorization.k8s.io/cnrm-network-viewer-super-awesome-grd-rails-54321 apply successful
configmap/setters apply successful
iampartialpolicy.iam.cnrm.cloud.google.com/super-awesome-grd-rails-54321-sa-workload-identity-binding apply successful
iampolicymember.iam.cnrm.cloud.google.com/gcp-ha-demo-353515-org-policyadmin apply successful
...
iampolicymember.iam.cnrm.cloud.google.com/config-controller-project-org-policyadmin reconcile successful
reconcile phase finished
inventory update started
inventory update finished
apply result: 54 attempted, 53 successful, 0 skipped, 1 failed
prune result: 3 attempted, 3 successful, 0 skipped, 0 failed
reconcile result: 61 attempted, 60 successful, 1 skipped, 0 failed, 0 timed out
```

You can view the status of the deployed resources by running the following commands:

```shell
kubectl get gcp -n config-control
```

The output should be similar to the below.

```plaintext
NAME                                                                    AGE   READY   STATUS     STATUS AGE
bigquerydataset.bigquery.cnrm.cloud.google.com/bigquerylogginglogsink   25m   True    UpToDate   25m

NAME                                                      AGE   READY   STATUS     STATUS AGE
iamauditconfig.iam.cnrm.cloud.google.com/org-audit-logs   30m   True    UpToDate   30m

NAME                                                                                                    AGE   READY   STATUS     STATUS AGE
iampartialpolicy.iam.cnrm.cloud.google.com/super-awesome-grd-rails-123456-sa-workload-identity-binding   50m   True    UpToDate   36m

NAME                                                                                           AGE    READY   STATUS     STATUS AGE
iampolicymember.iam.cnrm.cloud.google.com/asset-inventory-viewer                               30m    True    UpToDate   29m
iampolicymember.iam.cnrm.cloud.google.com/billing-console-viewer                               30m    True    UpToDate   29m
iampolicymember.iam.cnrm.cloud.google.com/bq-audit-data-user                                   30m    True    UpToDate   29m
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
| Org Logging Config Writer | Config Controller | Org | |
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
| Cloud Scheduler Job | Guardrails | Project ||
| Source Repository Service | Guardrails | Project ||
| Cloud Source Repository | Guardrails | Project ||

### View package content

`kpt pkg tree guardrails`
Details: <https://kpt.dev/reference/cli/pkg/tree/>

Details: <https://kpt.dev/reference/cli/live/>
