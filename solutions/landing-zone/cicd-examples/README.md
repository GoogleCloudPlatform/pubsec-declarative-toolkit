# CICD Examples

Current Examples

- Gitlab CI
- Cloud Build

Both of these examples will run two steps to help vet and validate the Configuration of your Landing Zone.

The first step is running the `nomos` [cli](https://cloud.google.com/anthos-config-management/docs/how-to/nomos-command#vet) tool to check the syntax and validity of your configurations. This will generate the same errors you would get if you tried to deploy using GitOps and Anthos Config Management.
