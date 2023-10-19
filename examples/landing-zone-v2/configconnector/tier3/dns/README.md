# Compute Address

This example creates a DNS `A` Record referencing a compute external IP address.

## IAM
The following permission in the `client-setup-project` allows for the creation of the Tier 3 DNS record.

[project-id-tier3.yaml](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/blob/main/solutions/client-project-setup/namespaces/project-id-tier3.yaml)

```yaml
# Grant GCP role Tier3 DNS Record Admin to GCP SA on Client Host Project
# AC-3(7) - ACCESS ENFORCEMENT | ROLE-BASED ACCESS CONTROL
apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMPolicyMember
metadata:
  name: project-id-tier3-sa-tier3-dnsrecord-admin-host-project-id-permissions # kpt-set: ${project-id}-tier3-sa-tier3-dnsrecord-admin-${host-project-id}-permissions
  namespace: client-name-projects # kpt-set: ${client-name}-projects
  annotations:
    cnrm.cloud.google.com/ignore-clusterless: "true"
    config.kubernetes.io/depends-on: resourcemanager.cnrm.cloud.google.com/namespaces/client-name-projects/Project/project-id # kpt-set: resourcemanager.cnrm.cloud.google.com/namespaces/${client-name}-projects/Project/${project-id}
spec:
  resourceRef:
    apiVersion: resourcemanager.cnrm.cloud.google.com/v1beta1
    kind: Project
    name: host-project-id # kpt-set: ${host-project-id}
  role: organizations/org-id/roles/tier3.dnsrecord.admin # kpt-set: organizations/${org-id}/roles/tier3.dnsrecord.admin
  member: "serviceAccount:tier3-sa@project-id.iam.gserviceaccount.com" # kpt-set: serviceAccount:tier3-sa@${project-id}.iam.gserviceaccount.com
```

The following permission in the `client-setup-project` allows for the creation of the Tier 3 external compute address.

[project-id-tier3.yaml](https://github.com/GoogleCloudPlatform/pubsec-declarative-toolkit/blob/main/solutions/client-project-setup/namespaces/project-id-tier3.yaml)

```yaml
# Grant GCP role Compute Public IP Admin to tier3-sa GCP SA
apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMPolicyMember
metadata:
  name: project-id-tier3-sa-compute-public-ip-admin-host-project-id-permissions # kpt-set: ${project-id}-tier3-sa-compute-public-ip-admin-${project-id}-permissions
  namespace: client-name-projects # kpt-set: ${client-name}-projects
  annotations:
    cnrm.cloud.google.com/ignore-clusterless: "true"
    config.kubernetes.io/depends-on: resourcemanager.cnrm.cloud.google.com/namespaces/client-name-projects/Project/project-id # kpt-set: resourcemanager.cnrm.cloud.google.com/namespaces/${client-name}-projects/Project/${project-id}
spec:
  resourceRef:
    apiVersion: resourcemanager.cnrm.cloud.google.com/v1beta1
    kind: Project
    name: project-id # kpt-set: ${project-id}
  role: roles/compute.publicIpAdmin
  member: "serviceAccount:tier3-sa@project-id.iam.gserviceaccount.com" # kpt-set: serviceAccount:tier3-sa@${project-id}.iam.gserviceaccount.com
```
