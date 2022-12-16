# Tenant Onboarding

### Pre-requisite
1. locally clone the landing zone repo for this environment
1. create a branch of main

## Add tenant folder(s) to the landing zone repository

  1. Move into source-base folder
      ```
      cd source-base
      ```
  1. get the hierarchy/tenant package
     - Sandbox
        ```
        kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/hierarchy/tenant-sandbox@main ./landing-zone/hierarchy/Workloads/<tenant name>
        ```

     - DEV, UAT, PROD
        ```
        # Automation
        kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/hierarchy/tenant-env@main ./landing-zone/hierarchy/Automation/<tenant name>

        # Workloads
        kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/hierarchy/tenant-env@main ./landing-zone/hierarchy/Workloads/<tenant name>

        # Workloads-Infrastructure
        kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/hierarchy/tenant-env@main ./landing-zone/hierarchy/Networking/Workloads-Infrastructure/<tenant name>
        ```
  1. To modify any of the files in these packages (like setters.yaml) follow this generic guidance
  
      Override `source-base` files by using a file with the same path and name inside the `source-customization` folder.
      
      For example, to override the `landing-zone/setters.yaml` for the `dev` environment, you will need to create a file `source-customization/dev/landing-zone/setters.yaml`. When the `hydrate.sh` is executed, it will replace/overlay files from `source-base` with the files from `source-customization` when rendering the files for the `dev` environment.


## Add tenant Host Project(s) and Shared VPC
TODO: complete this steps

## Add tenant Tier2-ConfigSync
TODO: complete this steps


