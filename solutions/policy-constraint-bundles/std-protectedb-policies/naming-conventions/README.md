# naming-conventions

## Description
sample description

## Usage

### Fetch the package
`kpt pkg get REPO_URI[.git]/PKG_PATH[@VERSION] naming-conventions`
Details: https://kpt.dev/reference/cli/pkg/get/

### View package content
`kpt pkg tree naming-conventions`
Details: https://kpt.dev/reference/cli/pkg/tree/

### Apply the package
```
kpt live init naming-conventions
kpt live apply naming-conventions --reconcile-timeout=2m --output=table
```
Details: https://kpt.dev/reference/cli/live/
