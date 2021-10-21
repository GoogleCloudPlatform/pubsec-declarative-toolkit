 GCP Canadian PubSec Sandbox

This Repo contains the configuration to deploy a Sandbox Environment based off on the GoC's 30 Day [Guardrails](https://github.com/canada-ca/cloud-guardrails).

## Prerequisites
- GCP Account
- [Cloud Shell](https://cloud.google.com/shell#:~:text=Cloud%20Shell%20is%20an%20online,tool%2C%20kubectl%2C%20and%20more.)
- [kpt](https://kpt.dev/)
- git

## Required Permissions
| Role | Description | Command |
| --- | --- | --- |
| Folder Creator | Used to create Folder for Configuratio Project | `gcloud organizations add-iam-policy-binding $ORG_ID --member="user:${USER_EMAIL}" --role='roles/resourcemanager.folderCreator'` |
| Project Creator | Required to create project for hosting GKE Cluster | `gcloud organizations add-iam-policy-binding $ORG_ID --member="user:${USER_EMAIL}" --role='roles/resourcemanager.projectCreator'` |
| Billing Account User | Required to attach a billing account to the host project | `gcloud organizations add-iam-policy-binding $ORG_ID --member="user:${USER_EMAIL}" --role='roles/billing.user'` |

## Quickstart
[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=git@github.com:GoogleCloudPlatform/gcp-pbmm-sandbox.git&cloudshell_workspace=.&cloudshell_tutorial=docs/cloudshell-tutorial.md)

Alternatively you can download the `bootstrap` script and following the steps in the following [Docs](docs/cloudshell-tutorial.md). To get download `bootstrap.sh` download it from the [releases page](https://github.com/GoogleCloudPlatform/gcp-pbmm-sandbox/releases) or use the following command:
```
release=v0.01
wget https://github.com/GoogleCloudPlatform/gcp-pbmm-sandbox/releases/download/${release}/bootstrap.sh
```

## Available Solutions
| Sandbox | Command |
| --- | --- |
| Private GKE Cluster | `kpt pkg get git@github.com:GoogleCloudPlatform/gcp-pbmm-sandbox.git/solutions/sandbox-gke` |

## What is a Solution Sandbox

This repostory contains a series of [KRM](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/) (Kubernetes Resource Model) `kpt` packages needed to deploy Sandbox Environments in Google Cloud. [kpt](https://kpt.dev/) is a Git-native, schema-aware, extensible client-side tool for packaging, customizing, validating, and applying Kubernetes resources.

Each `kpt` package contains configuration files to be used with a [Config Connector](https://cloud.google.com/config-connector/docs/overview) enabled Kubernetes Cluster or using the [Config Controller](https://cloud.google.com/anthos-config-management/docs/concepts/config-controller-overview) service.

These packages will container a package for Guardrails and a package for the associated Servce(s). For example the `sandbox-gke` bundles the `guardrails` and `private-gke` bundles to create its sandbox environment.

The Guardrails package contains the following Org Policies in order to help meet the 30 Day Guardrails benchment.

### Org Policies
| Org Policy | Usage | Guardrail Enforced |
|---|---|---|
| Restrict VM External Access | This list constraint defines the set of Compute Engine VM instances that are allowed to use external IP addresses. The allowed/denied list of VM instances must be identified by the VM instance name, in the form: projects/PROJECT_ID/zones/ZONE/instances/INSTANCE  | [06 - Network Security Services](https://github.com/canada-ca/cloud-guardrails/blob/master/EN/09_Network-Security-Services.md) |
| Require Trusted Images | This list constraint defines the set of projects that can be used for image storage and disk instantiation for Compute Engine. https://cloud.google.com/compute/docs/images/restricting-image-access |
| Restrict VPC Peering | This list constraint defines the set of VPC networks that are allowed to be peered with the VPC networks belonging to this project, folder, or organization. The allowed/denied list of networks must be identified in the form:  `organizations/ORGANIZATION_ID, folders/FOLDER_ID, projects/PROJECT_ID, or projects/PROJECT_ID/global/networks/NETWORK_NAME.` | [06 - Network Security Services](https://github.com/canada-ca/cloud-guardrails/blob/master/EN/09_Network-Security-Services.md) |
| Require Shielded VMs | This boolean constraint, when set to True, requires that all new Compute Engine VM instances use Shielded disk images with Secure Boot, vTPM, and Integrity Monitoring options enabled. Secure Boot can be disabled after creation, if desired. Existing running instances will continue to work as usual. |
| Resource Locations | This list constraint defines the set of locations where location-based GCP resources can be created. | [05 - Data Location](https://github.com/canada-ca/cloud-guardrails/blob/master/EN/05_Data-Location.md) |
| Disable VPC External IPV6 | This boolean constraint, when set to True, disables the creation of or update to subnetworks with a stack_type of IPV4_IPV6 and ipv6_access_type of EXTERNAL. | [06 - Network Security Services](https://github.com/canada-ca/cloud-guardrails/blob/master/EN/09_Network-Security-Services.md) |
| Disable Service Account Key Creation | This boolean constraint disables the creation of service account external keys where this constraint is set to `True`. | [02 - Management of Administrative Privileges](https://github.com/canada-ca/cloud-guardrails/blob/master/EN/02_Management-Admin-Privileges.md) |
| Enforce Uniform bucket-level IAM Access and management | This boolean constraint requires buckets to use uniform bucket-level access where this constraint is set to True. Any new bucket in the Organization resource must have uniform bucket-level access enabled, and no existing buckets in the organization resource can disable uniform bucket-level access. | [02 - Management of Administrative Privileges](https://github.com/canada-ca/cloud-guardrails/blob/master/EN/02_Management-Admin-Privileges.md) |
| Requires OS login for any SSH/RDP needs | This boolean constraint, when set to true, enables OS Login on all newly created Projects. All VM instances created in new projects will have OS Login enabled. On new and existing projects, this constraint prevents metadata updates that disable OS Login at the project or instance level. | [06 - Network Security Services](https://github.com/canada-ca/cloud-guardrails/blob/master/EN/09_Network-Security-Services.md) |
| Restrict Load Balancer Creation Based on Load Balancer Types | This list constraint defines the set of load balancer types which can be created for an organization, folder, or project. Every load balancer type to be allowed or denied must be listed explicitly.Options: `INTERNAL, EXTERNAL, INTERNAL_TCP_UDP, INTERNAL_HTTP_HTTPS, EXTERNAL_NETWORK_TCP_UDP EXTERNAL_TCP_PROXY, EXTERNAL_SSL_PROXY, EXTERNAL_HTTP_HTTPS, EXTERNAL_MANAGED_HTTP_HTTPS` | [06 - Network Security Services](https://github.com/canada-ca/cloud-guardrails/blob/master/EN/09_Network-Security-Services.md) |
| Domain restricted sharing |This list constraint defines one or more Cloud Identity or Google Workspace customer IDs whose principals can be added to IAM policies. To get instructions workspace ID make sure you are logged in as the admin user for admin.google.com In your Google Admin console (at admin.google.com)... Go to Account settings > Profile. Next to Customer ID, find your organization's unique ID. | [02 - Management of Administrative Privileges](https://github.com/canada-ca/cloud-guardrails/blob/master/EN/02_Management-Admin-Privileges.md) |
| Disable Serial Port Access | This boolean constraint disables serial port access to  Compute Engine VMs belonging to the organization, project, or folder where this constraint is set to True. | [02 - Management of Administrative Privileges](https://github.com/canada-ca/cloud-guardrails/blob/master/EN/02_Management-Admin-Privileges.md) |
| VM Can IP Forward | This list constraint defines the set of VM instances that can enable IP forwarding. By default, any VM can enable IP forwarding in any virtual network. VM instances must be specified in the form: `organizations/ORGANIZATION_ID, folders/FOLDER_ID, projects/PROJECT_ID, or projects/PROJECT_ID/zones/ZONE/instances/INSTANCE-NAME.`   | [06 - Network Security Services](https://github.com/canada-ca/cloud-guardrails/blob/master/EN/09_Network-Security-Services.md) |
| Disable VM nested virtualization | This boolean constraint disables hardware-accelerated nested virtualization for all Compute Engine VMs belonging to the organization, project, or folder where this constraint is set to True. ||
| Restrict shared VPC project lien removal | This boolean constraint restricts the set of users that can remove a Shared VPC project lien without organization-level permission where this constraint is set to True. | [06 - Network Security Services](https://github.com/canada-ca/cloud-guardrails/blob/master/EN/09_Network-Security-Services.md) |
| Restrict Public IP access on Cloud SQL instances | This boolean constraint restricts configuring Public IP on Cloud SQL instances where this constraint is set to True. This constraint is not retroactive, Cloud SQL instances with existing Public IP access will still work even after this constraint is enforced. | [06 - Network Security Services](https://github.com/canada-ca/cloud-guardrails/blob/master/EN/09_Network-Security-Services.md) |
|Enforce Public Access Prevention (Preview) | Secure your Cloud Storage data from public exposure by enforcing public access prevention. This governance policy prevents existing and future resources from being accessed via the public internet by disabling and blocking ACLs and IAM permissions that grant access to allUsers and allAuthenticatedUsers | [06 - Network Security Services](https://github.com/canada-ca/cloud-guardrails/blob/master/EN/09_Network-Security-Services.md) |


### Folder Structure
A basic folder structure to deploy the included resources
- Guardrails
    - Configuration to comply with the GC 30 Day Guardrails
        - IAM Roles
        - Log Sinks
        - Source Control
        - Cloud Build Trigger and Scheduler for BreakGlass alerting.

### GKE Sandbox
The following services will be deployed into a GKE-Sandbox folder for learning and development.
- [Private GKE Instance](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters)
- [Artifact Registry](https://cloud.google.com/artifact-registry)
- [Secret Manager](https://cloud.google.com/secret-manager#:~:text=Secret%20Manager%20is%20a%20secure,audit%20secrets%20across%20Google%20Cloud.)
- [BinaryAuthorization](https://cloud.google.com/binary-authorization)
- [Anthos](https://anthos.dev/)