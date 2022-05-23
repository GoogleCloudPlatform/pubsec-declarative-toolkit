# Landing Zone

This is a reimplementation of [pbmm-on-gcp-onboarding](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding) Landing Zone in KRM.

## Usage

### Fetch the package
`kpt pkg get git@github.com:GoogleCloudPlatform/gcp-pbmm-sandbox.git/solutions/landing-zone landing-zone`
Details: https://kpt.dev/reference/cli/pkg/get/

## Description
sample description

Creates 3 Environments
- Common
- Non-prod
- Prod

Each environment contains the following resources:

### Common
| Resource | Name | Purpose |
| ---- | ---- | ---- |
| Access Context Manager | | |
| Core Audit Bunker | | |
| Core Folders | | |
| Core IAM | | |
| Core Org Custom Roles | | |
| Core Org Policy | | |
| Guardrails | | |
| Base Network Perimeter | | |

### Non-Prod
| Resource | Name | Purpose |
| ---- | ---- | ---- |
| VPC Service Control | | |
| Network Host Project | | |
| Firewall | | |

### Prod
| Resource | Name | Purpose |
| ---- | ---- | ---- |
| Network Host Project | | |
| VPC Service Controls | | |
| Firewall | | |
| Network Perimeter Project | | |
| Network HA Perimeter | | |
| Network Management Perimeter | | |
| Net Private Perimeter | | |
| Network Private Perimeter Firewall | | |
| Network Public Perimeter Firewall | | |

## Usage

### Fetch the package
`kpt pkg get REPO_URI[.git]/PKG_PATH[@VERSION] landing-zone`
Details: https://kpt.dev/reference/cli/pkg/get/

### View package content
`kpt pkg tree landing-zone`
Details: https://kpt.dev/reference/cli/pkg/tree/

### Apply the package
```
kpt live init landing-zone
kpt live apply landing-zone --reconcile-timeout=2m --output=table
```
Details: https://kpt.dev/reference/cli/live/
