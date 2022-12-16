# Landing zone building

## Create the repository

1. Clone the repository `https://github.com/ssc-spc-ccoe-cei/gcp-repo-template` in order to build the new `gcp-tier1-infra` or `gcp-sandbox-tier1-infra`

## Build the landing zone structure
1. Execute the steps prior to the `Make Code Changes` section from the `change.md`

1. Move into source-base folder
    ```
    cd source-base
    ```
1. Get the landing zone package
    ```
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/landing-zone-v2/landing-zone@main ./landing-zone
    ```
1. Get the hierarchy package
    - Sandbox
      ```
      kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/hierarchy/core-sandbox@main ./landing-zone/hierarchy
      ```

    - DEV, UAT, PROD
      ```
      kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/hierarchy/core-env@main ./landing-zone/hierarchy
      ```
1. Get the gatekeeper policies package
    ```
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/gatekeeper-policies@main ./landing-zone/gatekeeper-policies
    ```
1. Get the organization policies package
    ```
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/org-policies@main ./landing-zone/org-policies
    ```
1. Get the logging package
    TODO: TBD
1. etc.


## Customize each environment
- Override `source-base` files by using a file with the same path and name inside the `source-customization` folder
- For example : to override the `landing-zone/setters.yaml` for the `dev` environment 
    - create file `source-customization/dev/landing-zone/setters.yaml`
    When the `hydrate.sh` is executed, it will replace files from `source-base` with the files from `source-customization` when rendering the files for the `dev` environment.

## Complete the change
1. Execute the steps following the `Make Code Changes` section from the `change.md`
