# Standard Unclassified Policy Bundle

## Description

Policy bundle for enforcing Unclassified compliance.

This bundle is dependant on the `gatekeeper-policies` package.

## Policy Enforcement

By default the policies are set to `dry-run` and will only produce violation notices will not prevent non-compliant resources from being deployed.

For production environments it is recommended the policies be set to `deny`. This can be done by setting the `enforcementAction` field in the packages `Kptfile` to `deny` then running `kpt fn render` on the package to change all policies in the bundle.

This example is what the setting should look like when set to `deny`

```
apiVersion: kpt.dev/v1
kind: Kptfile
...
pipeline:
  mutators:
    - image: gcr.io/kpt-fn/set-enforcement-action:v0.1.0
      configMap:
        enforcementAction: deny
```

### Naming Convention

All Projects must have the following naming convention `aadmu-string`

```shell
client_code: ^(aa|bb|cc)
env_code: d # corresponds to environment `d` 
region_code: m # Region Code `m` for montreal
class_code: (u|a|b)- # unclassified | protected a | protected b
user_defined_string: '^[a-z][a-z0-9-]*[a-z0-9]$' # user string
```

### Required Labels
All Projects must have be labeled with a cost center code that matches the following pattern `^[a-zA-Z]+$`


## Usage

### Fetch the package
```shell
kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/policy-constraint-bundles/std-protectedb-policies unclass-policies
```

### View package content
```shell
kpt pkg tree unclass-policies
```

### Apply the package
```shell
kpt live init unclass-policies
kpt live apply unclass-policies --reconcile-timeout=2m --output=table
```