# Deploying FortiGate active-passive HA cluster to GCP using Terraform

We recommend to deploy A-P cluster using the terraform module published in [https://github.com/fortinet/terraform-google-fgt-ha-ap-lb](https://github.com/fortinet/terraform-google-fgt-ha-ap-lb) with a factory copy in [https://github.com/40net-cloud/fortigate-gcp-ha-ap-lb-terraform](https://github.com/40net-cloud/fortigate-gcp-ha-ap-lb-terraform). As a module, this code is NOT supposed to be copied and modified, but rather referenced from your own code. Below you will find some examples you can use in your own terraform templates.

Please note that GCP provider authentication is handled in *your* code, not in module. Examples below are missing the **provider** block, which will make the terraform attempt to pull credentials and project name from environment. It will automatically work if you deploy from Google Cloud Shell. Local gcloud installations will provide authentication, but you need to add project name to GOOGLE_PROJECT environment variable. CI/CD deployments should include an explicit **provider** block using service account key. See [Terraform provider documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication) for more options and details.


### [Minimal](minimal)

An example of absolute minimal code to make the module work.

### [Deploying to new networks](payg-new-subnets)

The module deploys into existing subnets. This example shows how to create new networks and reference them in module in a single deployment.

### [Public IP addresses](public-addresses-elb-frontend)

FortiGates in load balancer sandwich architecture can use multiple public IPs. This example shows how to deploy with multiple new or existing addresses.

### [PAYG licensing](licensing-payg)

Deploying HA cliuster with PAYG license (default).

### [BYOL licensing](licensing-byol)

Deploying HA cluster with traditional BYOL licenses.

### [FortiFlex licensing](licensing-flex)

Deploying HA cluster with FortiFlex tokens.

### [GVNIC driver](gvnic-custom-image)

FortiGates by default use virtio network driver. This example shows how to deploy with GVNIC driver

### [ARM-based instance families](arm-based-machine-type)

FortiGate supports deployment using ARM-based T2A machine types. See this example to find out about required options.

### [Adding API user and token](api-token)

The module supports creating an API user and generating a token for headless day-2 automation.  
