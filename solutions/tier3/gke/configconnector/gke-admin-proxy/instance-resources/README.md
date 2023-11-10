<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->
# instance-resources


<!-- END OF PRE-COMMIT-BLUEPRINT DOCS HOOK:TITLE -->



<!-- BEGINNING OF PRE-COMMIT-BLUEPRINT DOCS HOOK:BODY -->
gke-admin-proxy sub-package to deploy the instance resources.

Depends on setters from its parent package.

***Note:*** Some resources use a double dash (`--`) to separate setters value, to work around a known behavior described [here](https://github.com/GoogleContainerTools/kpt/issues/3330).

Multiple copies of this subpackage can exist by copying the entire folder to a new folder (i.e. subpackage2).
This may be required to manage GKE clusters located in different subnets/regions.

## Setters

|         Name          |                Value                | Type | Count |
|-----------------------|-------------------------------------|------|-------|
| client-name           | client-name                         | str  |    21 |
| gke-admins            | gke-admins                          | str  |     2 |
| host-project-id       | net-host-project-12345              | str  |     2 |
| instance-ip           | 1.2.3.4                             | str  |     1 |
| instance-machine-type | e2-small                            | str  |     1 |
| instance-name         | proxy1                              | str  |    21 |
| instance-os-image     | a-project-with-images/the-image     | str  |     1 |
| location              | northamerica-northeast1             | str  |     2 |
| network-name          | host-project-id-global-standard-vpc | str  |     2 |
| project-id            | project-id                          | str  |    23 |
| subnet-name           | host-project-id-subnet-name         | str  |     2 |

## Sub-packages

This package has no sub-packages.

## Resources

|       File        |              APIVersion               |       Kind        |                         Name                          |       Namespace        |
|-------------------|---------------------------------------|-------------------|-------------------------------------------------------|------------------------|
| address.yaml      | compute.cnrm.cloud.google.com/v1beta1 | ComputeAddress    | project-id--instance-name-ip                          | client-name-networking |
| firewall-iap.yaml | compute.cnrm.cloud.google.com/v1beta1 | ComputeFirewall   | project-id--instance-name-sa-iap-ssh-fwr              | client-name-networking |
| iam.yaml          | iam.cnrm.cloud.google.com/v1beta1     | IAMServiceAccount | project-id--instance-name-sa                          | client-name-admin      |
| iam.yaml          | iam.cnrm.cloud.google.com/v1beta1     | IAMPolicyMember   | project-id--instance-name-sa-iap-service-account-user | client-name-projects   |
| iam.yaml          | iam.cnrm.cloud.google.com/v1beta1     | IAMPolicyMember   | project-id--instance-name-iap-compute-admin           | client-name-projects   |
| instance.yaml     | compute.cnrm.cloud.google.com/v1beta1 | ComputeInstance   | project-id--instance-name                             | client-name-admin      |

## Resource References

- [ComputeAddress](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computeaddress)
- [ComputeFirewall](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computefirewall)
- [ComputeInstance](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computeinstance)
- [IAMPolicyMember](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iampolicymember)
- [IAMServiceAccount](https://cloud.google.com/config-connector/docs/reference/resource-docs/iam/iamserviceaccount)

## Usage

1.  Clone the package:
    ```shell
    kpt pkg get https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit.git/solutions/gke/configconnector/instance-resources@${VERSION}
    ```
    Replace `${VERSION}` with the desired repo branch or tag
    (for example, `main`).

1.  Move into the local package:
    ```shell
    cd "./instance-resources/"
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
