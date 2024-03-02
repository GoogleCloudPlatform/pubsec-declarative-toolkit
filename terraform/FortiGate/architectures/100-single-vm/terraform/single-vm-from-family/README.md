# single-vm-from-family

Basic example of creating a single FortiGate instance using image family rather than image URL.

To deploy simply run
```
terraform init
terraform apply
```

You will be asked about project, region, zone and prefix.

You can also use `deploy.sh` script to deploy with project, zone and region imported from your gcloud settings.

See also: [Getting started with Terraform](../../../../../howto-tf.md)
