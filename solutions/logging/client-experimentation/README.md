<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# client-experimentation-logging-package


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
> **!!! This package is being deprecated. The resources it deploys have been consolidated in the experimentation/client-landing-zone package**
**`Note:`** The [core-experimentation](../core-experimentation/) package must be deployed before deploying the `client-experimentation` logging package.

<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Package to deploy client-experimentation logging solution

## Setters

|           Name           |           Value           | Type | Count |
|--------------------------|---------------------------|------|-------|
| client-displayname       | Client1                   | str  |     2 |
| client-name              | client1                   | str  |     5 |
| logging-prj-id           | logging-prj-id-12345      | str  |     4 |
| retention-in-days        |                         1 | int  |     1 |
| retention-locking-policy | false                     | bool |     1 |

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
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/logging/client-experimentation@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd ".//solutions/logging/client-experimentation/"
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

# client-experimentation-logging-package - continued

**TODO:** Move documentation to docs repo?

## Client-Experimentation Logging Solution Overview

This package deploys the following resources:

- Log bucket for client platform and component logs for resources under the `clients` folder

  - The client bucket name will contain the `client-name` set in setters.yaml:

      ```yaml
      # kpt-set: platform-and-component-${client-name}-log-bucket`
      ```

  - Retention in Days configurable via setters.yaml

      ```yaml
      retention-in-days: 1
      ```

  - Retention locking policy configurable via setters.yaml

      ```yaml
      retention-locking-policy: false
      ```

- Folder log sink for platform and component logs for resources under the `clients` folder

  - Destination: Log bucket hosted inside the logging project

  - Includes the following types of logs:
    - Cloud DNS, Cloud NAT, Firewall Rules, VPC Flow, and HTTP(S)

    ```yaml
    filter: |-
        LOG_ID("dns.googleapis.com/dns_queries")
        OR (LOG_ID("compute.googleapis.com/nat_flows") AND resource.type="nat_gateway")
        OR (LOG_ID("compute.googleapis.com/firewall") AND resource.type="gce_subnetwork")
        OR (LOG_ID("compute.googleapis.com/vpc_flows") AND resource.type="gce_subnetwork")
        OR (LOG_ID("requests") AND resource.type="http_load_balancer")
    ```

  - Excludes all Security logs: Cloud Audit, Access Transparency, and Data Access Logs

    ```yaml
      exclusions:
        - description: Exclude Security logs
          disabled: false
          filter: |-
            LOG_ID("cloudaudit.googleapis.com/activity") OR LOG_ID("externalaudit.googleapis.com/activity")
            OR LOG_ID("cloudaudit.googleapis.com/system_event") OR LOG_ID("externalaudit.googleapis.com/system_event")
            OR LOG_ID("cloudaudit.googleapis.com/policy") OR LOG_ID("externalaudit.googleapis.com/policy")
            OR LOG_ID("cloudaudit.googleapis.com/access_transparency") OR LOG_ID("externalaudit.googleapis.com/access_transparency")
          name: exclude-security-logs
    ```

  - IAM permission to allow the service account tied to the folder log sink to write logs into the platform and component log bucket