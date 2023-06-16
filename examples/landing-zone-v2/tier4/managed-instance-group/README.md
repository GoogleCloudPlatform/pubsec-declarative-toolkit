# Managed Instance Group

This example creates a simple managed instance group for an debian instance template with nginx.

## IAM
The following permissions are required on the projects' allowed subnets until the [config connector resource](https://cloud.google.com/config-connector/docs/reference/resource-docs/compute/computeinstancegroupmanager) allows for specifying the MIG to use a specific service account when creating VMs. Currently, the `spec.serviceAccountRef` throws an error `Invalid value for field ''resource.serviceAccount'': ''tier4-sa@project-id.iam.gserviceaccount.com''. service account support is not yet available, invalid'`

```yaml
# iam-compute.yaml
# current workaround must be deployed in the repo with 'client-project-setup' (tier2)
apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMPolicyMember
metadata:
  name: project-id-cloud-services-sa-networkuser-allowed-nane1-subnet-permissions # kpt-set: ${project-id}-cloud-services-sa-networkuser-${allowed-nane1-subnet}-permissions
  namespace: client-name-networking # kpt-set: ${client-name}-networking
  annotations:
    cnrm.cloud.google.com/ignore-clusterless: "true"
spec:
  resourceRef:
    apiVersion: compute.cnrm.cloud.google.com/v1beta1
    kind: ComputeSubnetwork
    name: host-project-id-allowed-nane1-subnet # kpt-set: ${host-project-id}-${allowed-nane1-subnet}
  role: roles/compute.networkUser
  member: "serviceAccount:REPLACE_WITH_PROJECT_NUMBER@cloudservices.gserviceaccount.com"
---
apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMPolicyMember
metadata:
  name: project-id-cloud-services-sa-networkuser-allowed-nane2-subnet-permissions # kpt-set: ${project-id}-cloud-services-sa-networkuser-${allowed-nane2-subnet}-permissions
  namespace: client-name-networking # kpt-set: ${client-name}-networking
  annotations:
    cnrm.cloud.google.com/ignore-clusterless: "true"
spec:
  resourceRef:
    apiVersion: compute.cnrm.cloud.google.com/v1beta1
    kind: ComputeSubnetwork
    name: host-project-id-allowed-nane2-subnet # kpt-set: ${host-project-id}-${allowed-nane2-subnet}
  role: roles/compute.networkUser
  member: "serviceAccount:REPLACE_WITH_PROJECT_NUMBER@cloudservices.gserviceaccount.com"
```
