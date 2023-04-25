# Platform or Security Admin Onboarding

## Add admin folder(s) to the landing zone repository

1. Move to the root of the landing zone

    ```bash
    cd <LZ_FOLDER>
    ```

1. Get the hierarchy/admin-experimentation package

    ```kpt
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/hierarchy/admin-experimentation@main ./landing-zone/hierarchy/tests/admins/<admin name>
    ```

1. Customize the setters.yaml file

1. Render the Configs

    ```bash
    kpt fn render landing-zone
    ```

1. Deploy the infrastructure using either kpt or gitops-git or gitops-oci
