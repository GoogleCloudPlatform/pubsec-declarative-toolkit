# External HTTPS Load Balancer

This example creates components of a simple external HTTPS load balancer with its backend service provided by a managed instance group (created in tier4). The load balancer uses existing Cloud Armor policy, SSL Certificate, and SSL Policy.

![img](https://cloud.google.com/static/load-balancing/images/https-load-balancer-simple.svg)

[https://cloud.google.com/load-balancing/docs/https/setup-global-ext-https-compute](https://cloud.google.com/load-balancing/docs/https/setup-global-ext-https-compute)

## IAM
The following permissions are required on the project for the tier3-sa in order to manage load balancer resources:

```yaml
# iam-elb.yaml
# Grant GCP role Compute Security Admin to tier3-sa GCP SA for load balancer resources
apiVersion: iam.cnrm.cloud.google.com/v1beta1
kind: IAMPolicyMember
metadata:
  name: project-id-tier3-sa-lbadmin-permissions # kpt-set: ${project-id}-tier3-sa-lbadmin-permissions
  annotations:
    cnrm.cloud.google.com/ignore-clusterless: "true"
spec:
  resourceRef:
    kind: Project
    external: projects/project-id # kpt-set: projects/${project-id}
  role: roles/compute.loadBalancerAdmin
  member: "serviceAccount:tier3-sa@project-id.iam.gserviceaccount.com" # kpt-set: serviceAccount:tier3-sa@${project-id}.iam.gserviceaccount.com
```