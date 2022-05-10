Getting Started
===============

There are some prerequisites in order to deploy the sandbox.

Prerequisites
-------------

*   GCP Organization
*   GCP Account
*   [Cloud Shell](https://cloud.google.com/shell)
*   [kpt](https://github.com/GoogleContainerTools/kpt)
*   [git](https://git-scm.com/)

Cloud Shell comes pre-installed with git and kpt.

### Predefined Roles

| Role | Description | Command |
| --- | --- | --- |
| Folder Creator | Used to create Folder for Configuration Project | `gcloud organizations add-iam-policy-binding $ORG_ID --member="user:${USER_EMAIL}" --role='roles/resourcemanager.folderCreator'`|
| Project Creator | Required to create project for hosting GKE Cluster | `gcloud organizations add-iam-policy-binding $ORG_ID --member="user:${USER_EMAIL}" --role='roles/resourcemanager.projectCreator'` |
| Billing Account User | Required to attach a billing account to the host project | `gcloud organizations add-iam-policy-binding $ORG_ID --member="user:${USER_EMAIL}" --role='roles/billing.user'` |

EITHER

| Role | Description | Command |
| --- | --- | --- |
| Organization Policy Administrator | Required to adjust Organizational Policies on the configuration project folder | `gcloud organizations add-iam-policy-binding $ORG_ID --member="user:${USER_EMAIL}" --role='roles/orgpolicy.policyAdmin'` |
| Security Administrator | Required to apply IAM Policies to a Service Account at the Org level | `gcloud organizations add-iam-policy-binding $ORG_ID --member="user:${USER_EMAIL}" --role='roles/iam.securityAdmin'` |

OR JUST

| Role | Description | Command |
| --- | --- | --- |
| Organization Administrator | Required to apply IAM Policies to a Service Account at the Org Level and adjust org policies | `gcloud organizations add-iam-policy-binding $ORG_ID --member="user:${USER_EMAIL}" --role='roles/resourcemanager.organizationAdmin'` | 

### Custom Role - Required Permissions

If you wish to create a custom role for the bootstrap process then the following permissions need to be added to the role. _NOTE_: The user will also need to assigned the Organization Policy Administrator Role as these permission can not be assigned to a custom role.
