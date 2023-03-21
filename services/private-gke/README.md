# private-gke

## Description
sample description

## Usage

### Fetch the package
`kpt pkg get REPO_URI[.git]/PKG_PATH[@VERSION] private-gke`
Details: https://kpt.dev/reference/cli/pkg/get/

### View package content
`kpt pkg tree private-gke`
Details: https://kpt.dev/reference/cli/pkg/tree/

### Apply the package
```
kpt live init private-gke
kpt live apply private-gke --reconcile-timeout=2m --output=table
```
Details: https://kpt.dev/reference/cli/live/
