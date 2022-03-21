# landing-zone

## Description
sample description

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
