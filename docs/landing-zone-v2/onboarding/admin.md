# Platform or Security Admin Onboarding

### Pre-requisite
1. locally clone the sandbox landing zone repo
1. create a branch of main

## Add admin folder(s) to the landing zone repository

  1. Move into the source-base folder
      ```
      cd source-base
      ```
  1. get the hierarchy/admin-sandbox package
        ```
        kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/hierarchy/admin-sandbox@main ./landing-zone/hierarchy/Testing/<admin name>
        ```
  1. To modify any of the files in this package (like setters.yaml) follow this generic guidance
  
      Override `source-base` files by using a file with the same path and name inside the `source-customization` folder.
      
      For example, to override the `landing-zone/setters.yaml` for the `dev` environment, you will need to create a file `source-customization/dev/landing-zone/setters.yaml`. When the `hydrate.sh` is executed, it will replace/overlay files from `source-base` with the files from `source-customization` when rendering the files for the `dev` environment.


