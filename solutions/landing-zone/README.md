# KRM Landing Zone

This is a reimplementation of [pbmm-on-gcp-onboarding](https://github.com/GoogleCloudPlatform/pbmm-on-gcp-onboarding) Landing Zone in KRM.

## Usage

To deploy this LAnding Zone you will first need to create a Bootstrap project with a Config Controller instance.

1. Deploy Bootstrap

```
arete create landing-zone-controller
```

This command will create a new project and deploy a Config Controller instance for you.

2. Fetch the package
`kpt pkg get git@github.com:GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/landing-zone landing-zone`
Details: https://kpt.dev/reference/cli/pkg/get/

3. Set Organization Hierarchy

4. Customize Package

5. Deploy

    a. kpt
    b. GitOps
    c. Arete

## Description

This landing Zone will create an initial 3 environments.

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
