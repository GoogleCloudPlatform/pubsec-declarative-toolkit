# 30 Day Cloud Guardrails Policies For Gatekeeper

This package contains a series of policies which are designed to help enforce the GCs [Cloud Guardrails](https://github.com/canada-ca/cloud-guardrails) Framework with deployments using Kubernetes [Config Connector Resources](https://cloud.google.com/config-connector/docs/reference/overview) in [Config Controller](https://cloud.google.com/anthos-config-management/docs/concepts/config-controller-overview) or a self-managed instance. 

Below is a description of each policy being enforced and what they are enforcing.

## Enterprise Monitoring Accounts ([link](https://github.com/canada-ca/cloud-guardrails/blob/master/EN/04_Enterprise-Monitoring-Accounts.md))

Assign roles to approved GC stakeholders to enable enterprise visibility. Roles include billing reader, policy contributor/reader, security reader, and global reader.

### Validation
- Confirm presence of GC enterprise role-based accounts created by Department for GC approved stakeholders.
- Confirm that accounts have appropriate read access to Departmental tenant environment.

### How this policy helps.
Policy validates named accounts are created and using a customrole with the following permissions
- `dataprocessing.groupcontrols.list`
- `monitoring.dashboards.get`
- `monitoring.groups.get`
- `monitoring.services.get`
- `orgpolicy.policy.get`
- `resourcemanager.projects.get`

## Data Location ([link](https://github.com/canada-ca/cloud-guardrails/blob/master/EN/05_Data-Location.md))

Validate Services are created in Approved Regions (Canada)

### Validation
Confirm policy and tagging for data location.

### How this policy assists

Default Approved Regions
- `northamerica-northeast1` (Montreal)
- `northamerica-northeast2` (Toronto)

## Network Security Services ([link](https://github.com/canada-ca/cloud-guardrails/blob/master/EN/09_Network-Security-Services.md))

Validate Services are not using External IPs and Networks do not auto-create Subnetworks

### Validation

- Confirm policy for network boundary protection.
- Confirm policy for limiting number of public IPs.
- Confirm policy for limiting to authorized source IP addresses (e.g. GC IP addresses).

### How this policy assists
- Disable Public IPs in the following services
    - GKE
    - Cloud SQL
- Disallowing auto-create sub-nets in new Networks to prevent subnets created in unapproved regions
Ensure that access to cloud storage services is protected and restricted to authorized users and services.
- Disallow Buckets with Public Access

## Logging and Monitoring

### Validation
- Confirm policy for event logging is implemented.
- Confirm event logs are being generated.
- Confirm that security contact information has been configured to receive alerts and notifications.

### How this Policy Helps

Validate storage sinks are created for log aggregation in PubSub, Cloud Storage and Big Query.

## CloudMarket Place
Validate IAM role for access to Market place is not assigned 

### Validation

Confirm that third-party marketplace restrictions have been implemented.

### How this Policy Helps

Validates no account has been created with the required permissions to access the MarketPlace `roles/cloudprivatecatalogproducer.admin`

## Usage

### Fetch the package
`kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/guardrails-policies guardrails-policies`
Details: https://kpt.dev/reference/cli/pkg/get/

### View package content
`kpt pkg tree guardrails-policies`
Details: https://kpt.dev/reference/cli/pkg/tree/
