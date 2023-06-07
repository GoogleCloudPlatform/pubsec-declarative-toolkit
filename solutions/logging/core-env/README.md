<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# core-env-logging-package

<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
> **!!! This package is being deprecated. The resources it deploys have been consolidated in the core-landing-zone package**
<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Landing zone v2 subpackage.
Package to deploy core-env logging solution

## Setters

|               Name                |                  Value                  | Type | Count |
|-----------------------------------|-----------------------------------------|------|-------|
| billing-id                        | AAAAAA-BBBBBB-CCCCCC                    | str  |     1 |
| logging-project-id                | logging-project-12345                   | str  |    21 |
| management-project-id             | management-project-12345                | str  |     2 |
| org-id                            |                              0000000000 | str  |     1 |
| platform-and-component-log-bucket | platform-and-component-log-bucket-12345 | str  |     2 |
| retention-in-days                 |                                       1 | int  |     2 |
| retention-locking-policy          | false                                   | bool |     2 |
| security-log-bucket               | security-log-bucket-12345               | str  |     1 |

## Sub-packages

This package has no sub-packages.

## Resources

|            File            |                  APIVersion                   |       Kind       |                                   Name                                    | Namespace |
|----------------------------|-----------------------------------------------|------------------|---------------------------------------------------------------------------|-----------|
| cloud-logging-buckets.yaml | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogBucket | security-log-bucket                                                       | logging   |
| cloud-logging-buckets.yaml | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogBucket | platform-and-component-log-bucket                                         | logging   |
| folder-sinks.yaml          | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogSink   | platform-and-component-services-log-sink                                  | logging   |
| folder-sinks.yaml          | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogSink   | platform-and-component-services-infra-log-sink                            | logging   |
| mgmt-project-sink.yaml     | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogSink   | mgmt-project-cluster-platform-and-component-log-sink                      | logging   |
| mgmt-project-sink.yaml     | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogSink   | mgmt-project-cluster-disable-default-bucket                               | logging   |
| org-sink.yaml              | logging.cnrm.cloud.google.com/v1beta1         | LoggingLogSink   | logging-project-id-security-sink                                          | logging   |
| project-iam.yaml           | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy | security-log-bucket-writer-permissions                                    | projects  |
| project-iam.yaml           | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy | platform-and-component-services-log-bucket-writer-permissions             | projects  |
| project-iam.yaml           | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy | platform-and-component-services-infra-log-bucket-writer-permissions       | projects  |
| project-iam.yaml           | iam.cnrm.cloud.google.com/v1beta1             | IAMPartialPolicy | mgmt-project-cluster-platform-and-component-log-bucket-writer-permissions | projects  |
| project-iam.yaml           | iam.cnrm.cloud.google.com/v1beta1             | IAMAuditConfig   | logging-project-data-access-log-config                                    | projects  |
| project.yaml               | resourcemanager.cnrm.cloud.google.com/v1beta1 | Project          | logging-project-id                                                        | projects  |

## Resource References

- [IAMAuditConfig](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iamauditconfig)
- [IAMPartialPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampartialpolicy)
- [LoggingLogBucket](https://cloud.google.com/config-connector/docs/reference/resource-docs/logging/logginglogbucket)
- [LoggingLogSink](https://cloud.google.com/config-connector/docs/reference/resource-docs/logging/logginglogsink)
- [Project](https://cloud.google.com/config-connector/docs/reference/resource-docs/resourcemanager/project)

## Usage

1.  Clone the package:

    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/logging/core-env@${VERSION}
    ```

    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:

    ```shell
    cd "./core-env/"
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
