# Example Client Project Resources

> Work in progress.

Examples which can be used as a starting point to deploy resources in the client project namespaces (tier3/tier4).
They are not meant to be deployed as-is.
Remove/add/edit examples as required.

A top level `Kptfile` and common `setters.yaml` is provided but can be edited/removed/moved as required.

Some could be deployed multiple times for different workloads (i.e. load balancers), some only once per project (i.e. IAM permissions to create load balancers in the project).
