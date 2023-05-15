# Gatekeeper project naming policy

This package contains the constraint `constraint.yaml` and constraint template `template.yaml` files for the GCP `project` resource.

This naming policy evaluates each project's name using a series of regular expressions. A project resource can be broken down into the following pieces:

| Name | Description |
| -------- | --------- |
| client code | Two-character code representing a client. Multiple clients can be supported by using a regex that evaluates multiple codes such as this: '^(aa\|bb\|cc)' |
| Environment code  | One character code representing the environment for the project: `d = dev, p = production, e = experimentation, u = preprod`    |
| Region code  | Projects that are not created in specific zones fall into the global/multi-region resource category and are allocated the `m` letter code. Region and zonal resources support the `k` code for northamerica-northeast1 or `l` code for northamerica-northeast2  |
| Classification code  | The project's data classification code or rating: `u = unclassified, a = protected A, b = protected B`  |
| User defined string  | User defined string containing a two or three letter team or owner code (not enforced) followed by a descriptive name for the project |

## View package content

Run the following command to view the package content:

`kpt pkg tree naming-rules`

```kpt
Package "project"
├── [Kptfile]  Kptfile project-naming-rules
├── [constraint.yaml]  NamingPolicyProject namingpolicyproject
├── [setters.yaml]  ConfigMap setters
├── [suite.yaml]  Suite namingpolicyproject
├── [template.yaml]  ConstraintTemplate namingpolicyproject
└── tests
    ├── [project_allowed.yaml]  Project aadmu-pe-test-project
    └── [project_not_allowed.yaml]  Project zzxyq-pe-test-projectA
```

Details: <https://kpt.dev/reference/cli/pkg/tree/>

## Package details

| File | Purpose |
| -------- | --------- |
| Kptfile | Contains information about the package |
| constraint.yaml  | Defines parameters that the constraint template uses to evaluate whether project names are valid   |
| setters.yaml  | Setters serve as parameters for customizing field values  |
| suite.yaml  | Used to define tests and test cases  |
| template.yaml  | ConstraintTemplates define a way to validate some set of Kubernetes objects in Gatekeeper's Kubernetes admission controller. |
| project_allowed.yaml  | Contains a `valid` resource configuration based on constraints  |
| project_not_allowed.yaml  | Contains `an invalid` resource configuration based on constraints  |

## Project constraint details

### constraint.yaml

It contains the following parameters:

- client_code: Set via `setters.yaml`
- env_code: Set via `setters.yaml`. Contains the client_code + env_code from `setters.yaml` as `${client_code}${env_code}`
- region_code: Hardcoded as the letter `m`
- class_code: Hardcoded as the following string: `(u|a|b)-`
- user_defined_string: Hardcoded as the following string: `'^[a-z][a-z0-9-]*[a-z0-9]$'`

### template.yaml

Contains the following parameters as properties:

- client_code
- env_code
- region_code
- class_code
- user_defined_string

### setters.yaml

It contains the following parameters:

- `client_code`

- `env_code`

Important Notice:

You must change the client_code value to align with your needs. The env_code must also be changed to reflect your deployment environment.

### suite.yaml

This file contains the configuration for the project naming policy tests. Two project manifests have been created inside the `/tests` folder, including an `allowed` test case and a `not_allowed` test case.

Details:

<https://open-policy-agent.github.io/gatekeeper/website/docs/gator/#writing-test-suites>

### project_allowed.yaml

This file contains a `valid` project resource name.

### project_not_allowed.yaml

This file contains an `invalid` project resource name.
