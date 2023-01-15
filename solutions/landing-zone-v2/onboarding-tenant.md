# Tenant Onboarding

## Add tenant folder(s) to the landing zone repository

1. Move to the root of the landing zone
    ```
    cd <LZ_FOLDER>
    ```
1. Get the hierarchy/tenant package
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

1. Add tenant Host Project(s) and Shared VPC

   TODO: complete this steps

1. Customize the setters.yaml file

1. Render the Configs
    ```bash
    kpt fn render landing-zone
    ``` 
1. Deploy the infrastructure using either kpt or gitops-git or gitops-oci


