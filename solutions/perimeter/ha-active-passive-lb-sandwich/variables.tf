variable "credentials_file_path" {}
variable "service_account" {}
variable "project" {}
variable "name" {}
variable "region" {}
variable "zone" {}
variable "machine" {}
variable "image" {}
variable "license_file" {}
variable "license_file_2" {}
variable "password" {
  type        = string
  default     = "fortinet"
  description = "FGT Password"
}
variable "ubuntu_image" {}
# Instance Template variables
variable "tags" {}
variable "active_port1_ip" {}
variable "active_port2_ip" {}
variable "active_port3_ip" {}
variable "active_port4_ip" {}
variable "passive_port1_ip" {}
variable "passive_port2_ip" {}
variable "passive_port3_ip" {}
variable "passive_port4_ip" {}
variable "mask" {}
variable "external_gateway" {}
variable "internal_gateway" {}
variable "mgmt_gateway" {}
variable "mgmt_mask" {}
# vpc module
variable "vpcs" {}
# subnet module
variable "subnets" {}
variable "subnet_cidrs" {}
# Internal Load Balancer
variable "dest_range" {}
variable "priority" {}
variable "int_check_interval_sec" {}
variable "int_timeout_sec" {}
variable "int_unhealthy_threshold" {}
variable "int_port" {}
# External Load Balancer
variable "elb_check_interval_sec" {}
variable "elb_timeout_sec" {}
variable "elb_healthy_threshold" {}
variable "elb_unhealthy_threshold" {}
variable "elb_port" {}
