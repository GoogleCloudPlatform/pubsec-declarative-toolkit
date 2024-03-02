variable "region_dut" {
  type = string
  default = "us-west1"
}

variable "region_cli" {
  type = string
  default = "us-east1"
}

variable "prefix" {
  type = string
  default = "fgt-vpn-perf"
}

variable "firmware" {
  type = string
  default = "7.4.2"
}

variable "mtu" {
  type = number
  default = 1500
}

variable "tunnel_count" {
  type = number
  default = 4
}

variable "machine_type" {
  type = string
  default = "n2-standard-8"
}

variable "phase2_enc" {
  type = string
  default = "aes128gcm"
  description = "null-sha1 aes128-sha1 aes128gcm aes256gcm aes256-sha512 chacha20poly1305"
}

## variables used for auto provisioning of flex tokens

variable "flex_serials" {
  type = list(string)
  default = []
}
/*
variable "fgt_image" {
  type = string
  default = "fortinet-fgt-723-20221110-001-w-license"
}
*/
variable "opt_queues" {
  type = bool
  default = true
}

variable "opt_ipsec-soft-dec-async" {
  type = bool
  default = true
}

variable "opt_affinity" {
  type = bool
  default = true
}

variable "nic_type" {
  type = string
  default = "VIRTIO_NET"
}