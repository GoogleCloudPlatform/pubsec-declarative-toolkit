# client Onboarding

## Add client folder(s) to the landing zone repository

1. Move to the root of the landing zone
    ```
    cd <LZ_FOLDER>
    ```
1. Get the hierarchy/client package
   - Sandbox
      ```
      kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/hierarchy/client-sandbox@main ./landing-zone/hierarchy/clients/<client name>
      ```

   - DEV, UAT, PROD
      ```
      kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/hierarchy/client-env@main ./landing-zone/hierarchy/clients/<client name>
      ```

1. Add client Host Project(s) and Shared VPC

   TODO: complete this steps

1. Customize the setters.yaml file

1. Render the Configs
    ```bash
    kpt fn render landing-zone
    ``` 
1. Deploy the infrastructure using either kpt or gitops-git or gitops-oci


