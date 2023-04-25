# Create a Config Controller Cluster #

By calling the `arete create` command you can create a new Config Controller cluster in your GCP environment. For a the more advanced user or to see the general workflow, visit:

- <https://cloud.google.com/anthos-config-management/docs/how-to/config-controller-setup>
- [Advanced Install](/docs/advanced-install.md)

## Re-Running the command ##

The `arete create` command tracks the progress of creation of the Config Controller cluster in a locally cached file (defaults to home directory `~/.arete/.create`). If you get an error during the creation process and it can be addressed in GCP then you go into GCP to fix the problem and then re-run the command. Arete will not re-run successful previous steps.

However, if you removed a previous component or want to re-run the entire process then you will need to either modify or delete the `.create` file.

## Roles and Permissions ##

The caller of this command must have at minimum the following GCP roles:

- roles/billing.user
- roles/servicemanagement.serviceConsumer
- roles/compute.instanceAdmin.v1
- roles/krmapihosting.admin

Either

- roles/iam.securityAdmin

Or

- roles/resourcemanager.organizationAdmin
