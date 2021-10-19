# guardrails

## Description
sample description

## Usage

### Fetch the package
`kpt pkg get REPO_URI[.git]/PKG_PATH[@VERSION] guardrails`
Details: https://kpt.dev/reference/cli/pkg/get/

### View package content
`kpt pkg tree guardrails`
Details: https://kpt.dev/reference/cli/pkg/tree/

### Apply the package
```
kpt live init guardrails
kpt live apply guardrails --reconcile-timeout=2m --output=table
```
Details: https://kpt.dev/reference/cli/live/
