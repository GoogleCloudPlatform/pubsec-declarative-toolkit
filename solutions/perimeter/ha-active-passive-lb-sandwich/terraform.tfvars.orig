credentials_file_path       = "<CREDENTIALS>"
project                     = "<GCP_PROJECT>"
service_account             = "<SERVICE_ACCOUNT_EMAIL>"
name                        = "terraform-ha-lb"
region                      = "us-central1"
zone                        = ["us-central1-a", "us-central1-c"]
machine                     = "n2-standard-4"
ubuntu_image                = "projects/ubuntu-os-cloud/global/images/ubuntu-1804-bionic-v20210415"
image                       = "<IMAGE>"
license_file                = null
license_file_2              = null
tags                        = ["ha-instance"]
active_port1_ip             = "172.21.0.2"
active_port2_ip             = "172.21.1.2"
active_port3_ip             = "172.21.2.2"
active_port4_ip             = "172.21.3.2"
passive_port1_ip            = "172.21.0.3"
passive_port2_ip            = "172.21.1.3"
passive_port3_ip            = "172.21.2.3"
passive_port4_ip            = "172.21.3.3"
mask                        = "24"
external_gateway            = "172.21.0.1"
internal_gateway            = "172.21.1.1"
mgmt_gateway                = "172.21.3.1"
mgmt_mask                   = "255.255.255.0"
# Subnet Module
subnets                     = ["public-subnet", "private-subnet", "sync-subnet", "mgmt-subnet"]
subnet_cidrs                = ["172.21.0.0/24", "172.21.1.0/24", "172.21.2.0/24", "172.21.3.0/24"]
# VPCs
vpcs                        = ["public-vpc", "private-vpc", "sync-vpc", "mgmt-vpc"]
# Internal Load Balancer
int_check_interval_sec      = 3
int_timeout_sec             = 2
int_unhealthy_threshold     = 3
int_port                    = 8008
dest_range                  = "0.0.0.0/0"
priority                    = 100
# External Load Balancer
elb_check_interval_sec      = 5
elb_timeout_sec             = 3
elb_healthy_threshold       = 1
elb_unhealthy_threshold     = 2
elb_port                    = 8008
