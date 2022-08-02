# Solution YAML

This file describes the yaml spec for solutions that are deployed with arete.

```
apiVersion: arete/v1alpha1                                      # version of the configuration
kind: Config                                                    # always `Config`
metadata:                                                       # hold additional information about the config
  name:                                                         # solution name
requires:                                                       # describesa list of required components for the solution to function
  - iam: "roles/gcp.reader"                                     # IAM roles that need to assigned the solution deployer prior to deployment
deploy:                                                         # deployment pipeline
  stage:                                                        # deployment pipeline stage
    infra:                                                      # infrastructure pipeline stage is expecting the a KCC endpoint
      kubeContext: "cluster name"                               # the name of the GKE cluster in which KCC is installed and setup on
        region: "gcp region"                                    # the region the GKE cluster is in. Set if the cluster is regional else use zone
        zone: "gcp zone"                                        # the zone the GKE cluster is in. Only one of region or zone should be set
        internalIP: "true|false"                                # use the internal IP address of the cluster endpoint or not
      iam:                                                      # setup the following IAM roles for the solution.
        - role:  "roles/gcp.reader"                             # role to be applied
          member: "user|serviceAccount|group:acct@example.com"  # account in which to apply the role
          resourceLevel: "organization|project"                 # add role binding at either the organization or project level
            id: "123abc"                                        # organization ID or Project ID
    app:                                                        # application pipeline stage
      kubeContext: "cluster name"                               # the name of the GKE cluster in which to deploy the application solution on, may be empty if the solution does not use GKE
        region: "gcp region"                                    # the region the GKE cluster is in. Set if the cluster is regional else use zone
        zone: "gcp zone"                                        # the zone the GKE cluster is in. Only one of region or zone should be set
        internalIP: "true|false"                                # use the internal IP address of the cluster endpoint or not
```