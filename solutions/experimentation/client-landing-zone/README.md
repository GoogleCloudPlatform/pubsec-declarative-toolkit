<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# client-landing-zone


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->

<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Landing zone v2 experimentation subpackage.
Depends on `experimentation/core-landing-zone`.

Package to create a client's folder hierarchy and logging resources.

## Setters

|           Name           |           Value           | Type | Count |
|--------------------------|---------------------------|------|-------|
| client-folderviewer      | group:client1@example.com | str  |     1 |
| client-name              | client1                   | str  |    13 |
| logging-project-id       | logging-project-12345     | str  |     4 |
| retention-in-days        |                         1 | int  |     1 |
| retention-locking-policy | false                     | bool |     1 |

## Sub-packages

This package has no sub-packages.

## Resources

|                   File                    |                  APIVersion                   |       Kind       |                               Name                               | Namespace |
|-------------------------------------------|-----------------------------------------------|------------------|------------------------------------------------------------------|-----------|
| client-folder/applications/folder.yaml    | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder           | clients.client-name.applications                                 | hierarchy |
| client-folder/folder-iam.yaml             | iam.cnrm.cloud.google.com/v1beta1             | IAMPolicyMember  | clients.client-name-client-folder-viewer-permissions             | hierarchy |
| client-folder/folder-sink.yaml            | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogSink   | platform-and-component-log-client-name-log-sink                  | logging   |
| client-folder/folder.yaml                 | resourcemanager.cnrm.cloud.google.com/v1beta1 | Folder           | clients.client-name                                              | hierarchy |
| logging-project/cloud-logging-bucket.yaml | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogBucket | platform-and-component-client-name-log-bucket                    | logging   |
| logging-project/project-iam.yaml          | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy | platform-and-component-log-client-name-bucket-writer-permissions | projects  |

## Resource References

- [Folder](https://cloud.google.com/config-connector/docs/reference/resource-docs/resourcemanager/folder)
- [IAMPartialPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampartialpolicy)
- [IAMPolicyMember](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampolicymember)
- [LoggingLogBucket](https://cloud.google.com/config-connector/docs/reference/resource-docs/logging/logginglogbucket)
- [LoggingLogSink](https://cloud.google.com/config-connector/docs/reference/resource-docs/logging/logginglogsink)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/experimentation/client-landing-zone@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./client-landing-zone/"
    ```

1.  Edit the function config file(s):
    - setters.yaml

1.  Execute the function pipeline
    ```shell
    kpt fn render
    ```

1.  Initialize the resource inventory
    ```shell
    kpt live init --namespace ${NAMESPACE}
    ```
    Replace `${NAMESPACE}` with the namespace in which to manage
    the inventory ResourceGroup (for example, `config-control`).

1.  Apply the package resources to your cluster
    ```shell
    kpt live apply
    ```

1.  Wait for the resources to be ready
    ```shell
    kpt live status --output table --poll-until current
    ```

<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
