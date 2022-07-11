# KRM Landing Zone

This is a reimplementation of [pbmm-on-gcp-onboarding](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding) Landing Zone using KRM.

## Organzation

This landing Zone will create an initial 3 environments.

Creates 3 Environments
- Common
- Non-prod
- Prod

These configurations for these environments is contained in the environments directory of this package.

This landing zone will deploy the following folder structure and projects. 

*Assume folder unless identified as a project*

```
Infrastructure:
  - Networking:
      - ProdNetworking
        - Production Network Project
      - NonProdNetworking
        - Non Production Network Project
  - SharedInfrastructure
Sandbox
Workloads:
  - Prod
  - UAT
  - DEV
Audit and Security:
  - Audit
    - Guardrails Project
    - Audit Bunker Project
  - Security
    - Common Network Perimeter Project
Automation
Shared Services
```

The following resources will be deployed.

### Common
| Resource | Name | Purpose | Status | Location |
| ---- | ---- | ---- | --- | -- |
| Access Context Manager | | | Work In Progress | `environments/common/vpc-service-controls`
| Core Audit Bunker | | | Available | `environments/common/audit` |
| Core Folders | | | Available | `environments/common/hiearchy.yaml` |
| Core IAM | | | Available | `environments/common/iam` |
| Core Org Custom Roles | | File for Custom Org Roles | Available | `environments/common/iam` |
| Core Org Policy | | Default Org Policies | Available | `environments/common/policies` |
| Guardrails | | | Available | `environments/common/guardrails-policies` |
| Base Network Perimeter | | | Available | `environments/common/network` |
| Network Management Perimeter | | | Available | `environments/common/network` |

### Non-Prod
| Resource | Name | Purpose | Status | Location |
| ---- | ---- | ---- | --- | -- |
| VPC Service Control | | | Available | `environments/nonprod/shared-vpc` |
| VPN Controllers | |  | Not Available | `environments/nonprod/network` |
| Network Host Project | | | Available | `environments/nonprod/network` |
| Firewall | | | Available | `environments/nonprod/firewall` |

### Prod
| Resource | Name | Purpose | Status | Location |
| ---- | ---- | ---- | --- | -- |
| Network Host Project | | | Available | `environments/nonprod/network` |
| VPC Service Controls | | | Available | `environments/nonprod/vpc-service-controls` |
| Network Perimeter Project | | | Available | `environments/nonprod/network` |
| Network HA Perimeter | | | Available | `environments/nonprod/network` |
| Net Private Perimeter | | | Available | `environments/nonprod/network` |
| Firewall | | | Available | `environments/nonprod/firewall` |
| Network Private Perimeter Firewall | | | Available | `environments/nonprod/firewall` |
| Network Public Perimeter Firewall | | | Available | `environments/nonprod/firewall` |


## Usage

To deploy this Landing Zone you will first need to create a Bootstrap project with a Config Controller instance.

1. Deploy Bootstrap

    ```
    arete create landing-zone-controller
    ```

    This command will create a new project and deploy a Config Controller instance for you.

    Set Permissions
    ```
    gcloud organizations add-iam-policy-binding "${ORG_ID}"     --member "serviceAccount:${SA_EMAIL}"     --role roles/accesscontextmanager.policyAdmin
    ```
    cloudbilling.googleapis.com
    roles/compute.xpnAdmin
    
2. Fetch the package

    `kpt pkg get git@github.com:GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/landing-zone landing-zone`

    Details: https://kpt.dev/reference/cli/pkg/get/

3. Set Organization Hierarchy


4. Customize Package

5. Deploy

    a. kpt
    
    ```
    kpt live init landing-zone
    kpt live apply landing-zone --reconcile-timeout=2m --output=table
    ```

    b. GitOps

    c. Arete
