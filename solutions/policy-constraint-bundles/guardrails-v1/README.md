# guardrails-v1

## Description
sample description

## Usage

### Fetch the package
`kpt pkg get REPO_URI[.git]/PKG_PATH[@VERSION] guardrails-v1`
Details: https://kpt.dev/reference/cli/pkg/get/

### View package content
`kpt pkg tree guardrails-v1`
Details: https://kpt.dev/reference/cli/pkg/tree/

### Apply the package
```
kpt live init guardrails-v1
kpt live apply guardrails-v1 --reconcile-timeout=2m --output=table
```
Details: https://kpt.dev/reference/cli/live/
