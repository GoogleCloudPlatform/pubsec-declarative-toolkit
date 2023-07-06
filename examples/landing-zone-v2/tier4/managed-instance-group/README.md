# Managed Instance Group

This example creates a simple managed instance group for an debian instance template with nginx.

## IAM
These permissions are required for the tier4-sa.  They can be granted from tier3.

```yaml
# Grant GCP roles to tier4-sa GCP SA
apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMPartialPolicy
metadata:
  name: project-id-tier4-sa-permissions # kpt-set: ${project-id}-tier4-sa-permissions
  annotations:
    cnrm.cloud.google.com/ignore-clusterless: "true"
spec:
  resourceRef:
    kind: Project
    external: projects/project-id # kpt-set: projects/${project-id}
  bindings:
    # to manage service accounts
    - role: roles/iam.serviceAccountAdmin
      members:
        - member: "serviceAccount:tier4-sa@project-id.iam.gserviceaccount.com" # kpt-set: serviceAccount:tier4-sa@${project-id}.iam.gserviceaccount.com
    # to use service accounts
    - role: roles/iam.serviceAccountUser
      members:
        - member: "serviceAccount:tier4-sa@project-id.iam.gserviceaccount.com" # kpt-set: serviceAccount:tier4-sa@${project-id}.iam.gserviceaccount.com
    # to manage compute instance resources
    - role: roles/compute.instanceAdmin
      members:
        - member: "serviceAccount:tier4-sa@project-id.iam.gserviceaccount.com" # kpt-set: serviceAccount:tier4-sa@${project-id}.iam.gserviceaccount.com
```

Network user permissions are also required on the projects' allowed subnets until the [config connector resource](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computeinstancegroupmanager) allows for specifying the MIG to use a specific service account when creating VMs.

Currently, the `spec.serviceAccountRef` throws an error `Invalid value for field ''resource.serviceAccount'': ''tier4-sa@project-id.iam.gserviceaccount.com''. service account support is not yet available, invalid'`

```yaml
# iam-compute.yaml
# current workaround must be deployed in the repo with 'client-project-setup' (tier2)
apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMPolicyMember
metadata:
  name: project-id-cloud-services-sa-networkuser-allowed-nane1-main-subnet-permissions # kpt-set: ${project-id}-cloud-services-sa-networkuser-${allowed-nane1-main-subnet}-permissions
  namespace: client-name-networking # kpt-set: ${client-name}-networking
  annotations:
    cnrm.cloud.google.com/ignore-clusterless: "true"
spec:
  resourceRef:
    apiVersion: compute.cnrm.cloud.google.com/v1beta1
    kind: ComputeSubnetwork
    name: allowed-nane1-main-subnet # kpt-set: ${allowed-nane1-main-subnet}
  role: roles/compute.networkUser
  member: "serviceAccount:REPLACE_WITH_PROJECT_NUMBER@cloudservices.gserviceaccount.com"
---
apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMPolicyMember
metadata:
  name: project-id-cloud-services-sa-networkuser-allowed-nane2-main-subnet-permissions # kpt-set: ${project-id}-cloud-services-sa-networkuser-${allowed-nane2-main-subnet}-permissions
  namespace: client-name-networking # kpt-set: ${client-name}-networking
  annotations:
    cnrm.cloud.google.com/ignore-clusterless: "true"
spec:
  resourceRef:
    apiVersion: compute.cnrm.cloud.google.com/v1beta1
    kind: ComputeSubnetwork
    name: allowed-nane2-main-subnet # kpt-set: ${allowed-nane2-main-subnet}
  role: roles/compute.networkUser
  member: "serviceAccount:REPLACE_WITH_PROJECT_NUMBER@cloudservices.gserviceaccount.com"
```
