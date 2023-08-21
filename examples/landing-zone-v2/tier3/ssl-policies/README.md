# SSL Policies

This example creates SSL Policies which can be later applied to frontends (such as load balancers).

[https://cloud.google.com/armor/docs/security-policy-overview](https://cloud.google.com/load-balancing/docs/ssl-policies-concepts)

It includes only SSL policies that are approved by Canadian Centre for Cyber Security.
[https://www.cyber.gc.ca/en/guidance/guidance-securely-configuring-network-protocols-itsp40062](https://www.cyber.gc.ca/en/guidance/guidance-securely-configuring-network-protocols-itsp40062)

## IAM

The following permissions are required on the project for the tier3-sa in order to manage SSL policies:

```yaml
# iam-ssl-policies.yaml
# Grant GCP role Compute Security Admin to tier3-sa GCP SA for SSL Policies
apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMPolicyMember
metadata:
  name: project-id-tier3-sa-computesecurityadmin-permissions # kpt-set: ${project-id}-tier3-sa-computesecurityadmin-permissions
  annotations:
    cnrm.cloud.google.com/ignore-clusterless: "true"
spec:
  resourceRef:
    kind: Project
    external: projects/project-id # kpt-set: projects/${project-id}
  role: roles/compute.securityAdmin
  member: "serviceAccount:tier3-sa@project-id.iam.gserviceaccount.com" # kpt-set: serviceAccount:tier3-sa@${project-id}.iam.gserviceaccount.com
```
