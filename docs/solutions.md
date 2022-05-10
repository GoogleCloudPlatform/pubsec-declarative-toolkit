Solutions and Services
=======================

What is a Solution
------------------

Solutions are made up of [KRM](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/) (Kubernetes Resource Model) KCC files that uses the [kpt](https://kpt.dev) method of packaging and deploying these resouces. A solution is typically made up of a collection of cloud resources that once created are fully configured and running.

Solutions may contain templated KCC services.

What is a Service
------------------
We define a service as a reusable / repeatable package that is more find grained then a complete pacakged solution. For example: we have created a Bastion Host service that uses best practices. Services are `kpt` packages that can be pulled into your solution as a sub-package, this sub-package method allows for seperation of updating the core solution and the services.
