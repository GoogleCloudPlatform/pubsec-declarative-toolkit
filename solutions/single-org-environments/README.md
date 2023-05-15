# single-org-environments

## Description
sample description

## Usage

### Fetch the package
`kpt pkg get REPO_URI[.git]/PKG_PATH[@VERSION] single-org-environments`
Details: https://kpt.dev/reference/cli/pkg/get/

### View package content
`kpt pkg tree single-org-environments`
Details: https://kpt.dev/reference/cli/pkg/tree/

### Apply the package
```
kpt live init single-org-environments
kpt live apply single-org-environments --reconcile-timeout=2m --output=table
```
Details: https://kpt.dev/reference/cli/live/
