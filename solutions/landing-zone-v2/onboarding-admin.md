# Platform or Security Admin Onboarding

## Add admin folder(s) to the landing zone repository

1. Move to the root of the landing zone
    ```
    cd <LZ_FOLDER>
    ```
1. Get the hierarchy/admin-sandbox package
    ```
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/hierarchy/admin-sandbox@main ./landing-zone/hierarchy/Testing/<admin name>
    ```
1. Customize the setters.yaml file

1. Render the Configs
    ```bash
    kpt fn render landing-zone
    ``` 
1. Deploy the infrastructure using either kpt or gitops-git or gitops-oci