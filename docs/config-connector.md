Getting Started - Config Connector
==================================

Running the quickstart will provision the necessary resources required to provision the sandbox environment.

Enables the following services
*   `krmapihosting.googleapis.com` (if using Config Controller)
*   `compute.googleapis.com`
*   `container.googleapis.com`
*   `cloudresourcemanager.googleapis.com`
*   A Private GKE Cluster with Workloadidentity and Config Connector enabled
*   A Service Account to be used by Config Connector with the following roles
    *   `roles/billing.user`
    *   `roles/compute.networkAdmin`
    *   `roles/compute.xpnAdmin`
    *   `roles/iam.organizationRoleAdmin`
    *   `roles/orgpolicy.policyAdmin`
    *   `roles/resourcemanager.folderAdmin`
    *   `roles/resourcemanager.organizationAdmin`
    *   `roles/resourcemanager.projectCreator`
    *   `roles/resourcemanager.projectDeleter`
    *   `roles/resourcemanager.projectIamAdmin`
    *   `roles/resourcemanager.projectMover`
    *   `roles/logging.configWriter`
    *   `roles/resourcemanager.projectIamAdmin`
    *   `roles/serviceusage.serviceUsageAdmin`
    *   `roles/bigquery.dataEditor`
    *   `storage.admin`