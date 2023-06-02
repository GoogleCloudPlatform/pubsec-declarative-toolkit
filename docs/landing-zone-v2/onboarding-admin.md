# Platform or Security Admin Onboarding

## Introduction

You will execute this procedure to provision a GCP folder for one `admin`. High privileges roles are granted to that `admin` on that folder so that he can explore and build solutions in GCP. This procedure must only be executed on an `Experimentation` Landing zone.

TODO: update this procedure
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
