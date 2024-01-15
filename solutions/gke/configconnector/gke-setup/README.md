<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# gke-setup


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->

<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
Landing zone v2 subpackage.
Depends on package `client-project-setup`.
Deploy this package once per service project.

Package to prepare a service project for GKE clusters. Permissions are granted onto the host project.

## Setters

|             Name             |              Value              | Type | Count |
|------------------------------|---------------------------------|------|-------|
| client-management-project-id | client-management-project-12345 | str  |     1 |
| client-name                  | client1                         | str  |    47 |
| gke-monitoring-group         | group@example.com               | str  |     1 |
| host-project-id              | net-host-project-12345          | str  |    10 |
| org-id                       |                      0000000000 | str  |     3 |
| project-id                   | project-12345                   | str  |    89 |
| project-number               |                      0000000000 | str  |     5 |

## Sub-packages

This package has no sub-packages.

## Resources

|                    File                     |                 APIVersion                 |             Kind              |                                        Name                                        |      Namespace       |
|---------------------------------------------|--------------------------------------------|-------------------------------|------------------------------------------------------------------------------------|----------------------|
| gkehub-feature-acm.yaml                     | gkehub.cnrm.cloud.google.com/v1beta1       | GKEHubFeature                 | project-id-acm-hubfeature                                                          | project-id-tier3     |
| host-project/project-iam.yaml               | iam.cnrm.cloud.google.com/v1beta1          | IAMPolicyMember               | project-id-cloudservices-sa-networkuser-host-project-id-permissions                | client-name-projects |
| host-project/project-iam.yaml               | iam.cnrm.cloud.google.com/v1beta1          | IAMPolicyMember               | project-id-container-engine-robot-sa-networkuser-host-project-id-permissions       | client-name-projects |
| host-project/project-iam.yaml               | iam.cnrm.cloud.google.com/v1beta1          | IAMPolicyMember               | project-id-container-engine-robot-sa-gkefirewall-admin-host-project-id-permissions | client-name-projects |
| host-project/project-iam.yaml               | iam.cnrm.cloud.google.com/v1beta1          | IAMPolicyMember               | project-id-tier3-sa-tier3-subnetwork-admin-host-project-id-permissions             | client-name-projects |
| host-project/project-iam.yaml               | iam.cnrm.cloud.google.com/v1beta1          | IAMPolicyMember               | project-id-container-engine-robot-sa-host-servce-agent-host-project-id-permissions | client-name-projects |
| logging-monitoring/alerts.yaml              | monitoring.cnrm.cloud.google.com/v1beta1   | MonitoringAlertPolicy         | project-id-gke-security-posture-critical-severity-alert                            | client-name-logging  |
| logging-monitoring/alerts.yaml              | monitoring.cnrm.cloud.google.com/v1beta1   | MonitoringAlertPolicy         | project-id-gke-security-posture-high-severity-alert                                | client-name-logging  |
| logging-monitoring/alerts.yaml              | monitoring.cnrm.cloud.google.com/v1beta1   | MonitoringAlertPolicy         | project-id-gke-security-posture-medium-severity-alert                              | client-name-logging  |
| logging-monitoring/alerts.yaml              | monitoring.cnrm.cloud.google.com/v1beta1   | MonitoringAlertPolicy         | project-id-gke-security-posture-low-severity-alert                                 | client-name-logging  |
| logging-monitoring/alerts.yaml              | monitoring.cnrm.cloud.google.com/v1beta1   | MonitoringAlertPolicy         | project-id-gke-cluster-event-notification-alert                                    | client-name-logging  |
| logging-monitoring/alerts.yaml              | monitoring.cnrm.cloud.google.com/v1beta1   | MonitoringAlertPolicy         | project-id-gke-cluster-upgrade-alert                                               | client-name-logging  |
| logging-monitoring/notificationchannel.yaml | monitoring.cnrm.cloud.google.com/v1beta1   | MonitoringNotificationChannel | project-id-gke-monitoring-group-notify                                             | client-name-logging  |
| logging-monitoring/pubsub.yaml              | pubsub.cnrm.cloud.google.com/v1beta1       | PubSubTopic                   | project-id-gke-cluster-notification-pubsub-topic                                   | client-name-logging  |
| logging-monitoring/pubsub.yaml              | pubsub.cnrm.cloud.google.com/v1beta1       | PubSubSubscription            | project-id-gke-cluster-notification-pubsub-subscription                            | client-name-logging  |
| project-iam.yaml                            | iam.cnrm.cloud.google.com/v1beta1          | IAMPolicyMember               | project-id-tier3-sa-gke-hub-admin-project-id-permissions                           | client-name-projects |
| project-iam.yaml                            | iam.cnrm.cloud.google.com/v1beta1          | IAMPolicyMember               | project-id-tier3-sa-container-admin-project-id-permissions                         | client-name-projects |
| project-iam.yaml                            | iam.cnrm.cloud.google.com/v1beta1          | IAMPolicyMember               | project-id-tier3-sa-service-agent-project-id-permissions                           | client-name-projects |
| project-iam.yaml                            | iam.cnrm.cloud.google.com/v1beta1          | IAMPolicyMember               | project-id-tier3-sa-kms-admin-project-id-permissions                               | client-name-projects |
| project-iam.yaml                            | iam.cnrm.cloud.google.com/v1beta1          | IAMPolicyMember               | project-id-container-engine-robot-sa-kms-encrypt-decrypt-project-id-permissions    | client-name-projects |
| project-iam.yaml                            | iam.cnrm.cloud.google.com/v1beta1          | IAMPolicyMember               | project-id-tier4-sa-artifactregistry-admin-project-id-permissions                  | client-name-projects |
| project-iam.yaml                            | iam.cnrm.cloud.google.com/v1beta1          | IAMPolicyMember               | project-id-tier4-sa-tier4-secret-manager-admin-project-id-permissions              | client-name-projects |
| project-iam.yaml                            | iam.cnrm.cloud.google.com/v1beta1          | IAMPolicyMember               | client-name-logging-sa-pubsub-admin-project-id-permissions                         | client-name-projects |
| services.yaml                               | serviceusage.cnrm.cloud.google.com/v1beta1 | Service                       | project-id-container                                                               | client-name-projects |
| services.yaml                               | serviceusage.cnrm.cloud.google.com/v1beta1 | Service                       | project-id-containersecurity                                                       | client-name-projects |
| services.yaml                               | serviceusage.cnrm.cloud.google.com/v1beta1 | Service                       | project-id-anthos                                                                  | client-name-projects |
| services.yaml                               | serviceusage.cnrm.cloud.google.com/v1beta1 | Service                       | project-id-anthosconfigmanagement                                                  | client-name-projects |
| services.yaml                               | serviceusage.cnrm.cloud.google.com/v1beta1 | Service                       | project-id-gkehub                                                                  | client-name-projects |
| services.yaml                               | serviceusage.cnrm.cloud.google.com/v1beta1 | Service                       | project-id-gkeconnect                                                              | client-name-projects |
| services.yaml                               | serviceusage.cnrm.cloud.google.com/v1beta1 | Service                       | project-id-kms                                                                     | client-name-projects |
| services.yaml                               | serviceusage.cnrm.cloud.google.com/v1beta1 | Service                       | project-id-secretmanager                                                           | client-name-projects |
| services.yaml                               | serviceusage.cnrm.cloud.google.com/v1beta1 | Service                       | project-id-artifactregistry                                                        | client-name-projects |
| services.yaml                               | serviceusage.cnrm.cloud.google.com/v1beta1 | Service                       | project-id-containerscanning                                                       | client-name-projects |
| services.yaml                               | serviceusage.cnrm.cloud.google.com/v1beta1 | Service                       | project-id-certificatemanager                                                      | client-name-projects |
| services.yaml                               | serviceusage.cnrm.cloud.google.com/v1beta1 | Service                       | project-id-pubsub                                                                  | client-name-projects |

## Resource References

- [GKEHubFeature](https://cloud.google.com/config-connector/docs/reference/resource-docs/gkehub/gkehubfeature)
- [IAMPolicyMember](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampolicymember)
- [MonitoringAlertPolicy](https://cloud.google.com/config-connector/docs/reference/resource-docs/monitoring/monitoringalertpolicy)
- [MonitoringNotificationChannel](https://cloud.google.com/config-connector/docs/reference/resource-docs/monitoring/monitoringnotificationchannel)
- [PubSubSubscription](https://cloud.google.com/config-connector/docs/reference/resource-docs/pubsub/pubsubsubscription)
- [PubSubTopic](https://cloud.google.com/config-connector/docs/reference/resource-docs/pubsub/pubsubtopic)
- [Service](https://cloud.google.com/config-connector/docs/reference/resource-docs/serviceusage/service)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/gke/configconnector/gke-setup@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./gke-setup/"
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
