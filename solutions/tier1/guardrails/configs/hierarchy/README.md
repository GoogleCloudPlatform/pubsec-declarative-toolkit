# hierarchy

## Description

This package is used to generate the folder structure to be used for your environment.

The default configuration will generate a single folder named `guardrails`

Additional folders can be added by modifying the `hierarchy.yaml` file and adding the desired structure.

For example the following structure would generate a folder for guardrails and a team folder with 2 sub-directories for deployment environments.

```yaml
config:
- guardrails:
    - null
- team1:
    - Dev
    - Production
```

The files will be generated when you run `kpt rn render`

## Usage

### Fetch the package

`kpt pkg get REPO_URI[.git]/PKG_PATH[@VERSION] hierarchy`
Details: <https://kpt.dev/reference/cli/pkg/get/>

### View package content

`kpt pkg tree hierarchy`
Details: <https://kpt.dev/reference/cli/pkg/tree/>

### Apply the package

```shell
kpt live init hierarchy
kpt live apply hierarchy --reconcile-timeout=2m --output=table
```

Details: <https://kpt.dev/reference/cli/live/>
