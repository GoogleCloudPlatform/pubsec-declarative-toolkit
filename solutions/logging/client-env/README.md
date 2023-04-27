<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# client-env-logging-package

<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Landing zone v2 subpackage.
Package to deploy client-env logging solution.
The core-env logging package must be deployed before this package.

## Setters

|           Name           |       Value        | Type | Count |
|--------------------------|--------------------|------|-------|
| client-displayname       | Client1            | str  |     2 |
| client-name              | client1            | str  |     5 |
| logging-project-id       | logging-project-id | str  |     4 |
| retention-in-days        |                  1 | int  |     1 |
| retention-locking-policy | false              | bool |     1 |

## Sub-packages

This package has no sub-packages.

## Resources

|           File            |              APIVersion               |       Kind       |                             Name                             | Namespace |
|---------------------------|---------------------------------------|------------------|--------------------------------------------------------------|-----------|
| cloud-logging-bucket.yaml | logging.cnrm.cloud.google.com/v1beta1 | LoggingLogBucket | platform-and-component-client1-log-bucket                    | logging   |
| folder-sink.yaml          | logging.cnrm.cloud.google.com/v1beta1 | LoggingLogSink   | platform-and-component-log-client1-log-sink                  | logging   |
| project-iam.yaml          | iam.cnrm.cloud.google.com/v1beta1     | IAMPartialPolicy | platform-and-component-log-client1-bucket-writer-permissions | projects  |

## Resource References

- [IAMPartialPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampartialpolicy)
- [LoggingLogBucket](https://cloud.google.com/config-connector/docs/reference/resource-docs/logging/logginglogbucket)
- [LoggingLogSink](https://cloud.google.com/config-connector/docs/reference/resource-docs/logging/logginglogsink)

## Usage

1.  Clone the package:

    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/logging/client-env/client-env-logging-package@${VERSION}
    ```

    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:

    ```shell
    cd "./client-env-logging-package/"
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
