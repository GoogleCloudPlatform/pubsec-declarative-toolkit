# Create a Config Controller Cluster #

By calling the `arete create` command you can create a new Config Controller cluster in your GCP environment. For a the more advanced user or to see the general workflow, visit:

- https://cloud.google.com/anthos-config-management/docs/how-to/config-controller-setup
- [Advanced Install](docs/advanced-install.md)

The caller of this command must have at minimum the following GCP roles:

- roles/billing.user
- roles/servicemanagement.serviceConsumer
- roles/compute.instanceAdmin.v1
- roles/krmapihosting.admin

Either
- roles/iam.securityAdmin

Or

- roles/resourcemanager.organizationAdmin