# federal-policy

## Description
sample description

## Usage

### Fetch the package
`kpt pkg get REPO_URI[.git]/PKG_PATH[@VERSION] federal-policy`
Details: https://kpt.dev/reference/cli/pkg/get/

### View package content
`kpt pkg tree federal-policy`
Details: https://kpt.dev/reference/cli/pkg/tree/

### Apply the package
```
kpt live init federal-policy
kpt live apply federal-policy --reconcile-timeout=2m --output=table
```
Details: https://kpt.dev/reference/cli/live/
