variable "instance_name" {
  type        = string
  default     = "fortigate-vm"
  description = "Name of the FortiGate VM instance"
}

variable "zone" {
  type        = string
  default     = ""
  description = "Name of the zone to deploy FortiGate to."
}

variable "subnets" {
  type        = list(string)
  description = "Names of existing subnets to be connected to FortiGate VM"
  validation {
    condition     = length(var.subnets) > 0
    error_message = "Please provide at least 1 subnet name."
  }
  validation {
    condition     = length(var.subnets) < 9
    error_message = "GCE instances are limited to maximum of 8 NICs (depending on machine type)."
  }
}

variable "machine_type" {
  type        = string
  default     = "e2-standard-2"
  description = "GCE machine type to use for VMs. Minimum 4 vCPUs are needed for 4 NICs"
}

variable "service_account" {
  type        = string
  default     = ""
  description = "E-mail of service account to be assigned to FortiGate VMs. Defaults to Default Compute Engine Account"
}

variable "license_file" {
  type        = string
  default     = ""
  description = "License (.lic) file to be applied for BYOL instance."
}

variable "flex_token" {
  type        = string
  default     = ""
  description = "FortiFlex token to be applied during bootstrapping"
}

variable "fgt_config" {
  type        = string
  description = "(optional) Additional configuration script to be added to bootstrap"
  default     = ""
}

variable "logdisk_size" {
  type        = number
  description = "Size of the attached logdisk in GB"
  default     = 30
  validation {
    condition     = var.logdisk_size > 10
    error_message = "Log disk size cannot be smaller than 10GB."
  }
}

variable "image" {
  type = object({
    project = optional(string, "fortigcp-project-001")
    name    = optional(string, "")
    family  = optional(string, "fortigate-74-payg")
    version = optional(string, "")
    arch    = optional(string, "x64")
    lic     = optional(string, "payg")
  })
  description = "Indicate FortiOS image you want to deploy by specifying one of the following: image family name (as image.family); firmware version, architecture and licensing (as image.version, image.arch and image.lic); image name (as image.name) optionally with image project name for custom images (as image.project)."
  default = {
    family = "fortigate-74-payg"
  }
  validation {
    condition     = contains(["arm", "x64"], var.image.arch)
    error_message = "image.arch must be either 'arm' or 'x64' (default: 'x64')"
  }
  validation {
    condition     = contains(["payg", "byol"], var.image.lic)
    error_message = "image.lic can be either 'payg' or 'byol' (default: 'payg'). For FortiFlex use 'byol'"
  }
  validation {
    condition     = anytrue([length(split(".", var.image.version)) == 3, var.image.version == ""])
    error_message = "image.version can be either null or contain FortiOS version in 3-digit format (eg. \"7.4.1\")"
  }
}

variable "labels" {
  type        = map(string)
  description = "Map of labels to be applied to the VMs, disks, and forwarding rules"
  default     = {}
}

variable "nic_type" {
  type        = string
  description = "Type of NIC to use for FortiGates. Allowed values are GVNIC or VIRTIO_NET"
  default     = "VIRTIO_NET"
  validation {
    condition     = contains(["GVNIC", "VIRTIO_NET"], var.nic_type)
    error_message = "Unsupported value of nic_type variable. Allowed values are GVNIC or VIRTIO_NET."
  }
}

variable "serial_port_enable" {
  type        = bool
  default     = false
  description = "Set to true to enable access to VM serial console"
}

variable "public_nics" {
  type        = list(string)
  default     = ["port1"]
  description = "List of FortiGate ports with attached External IPs."
}

variable "fgt_tags" {
  type        = list(string)
  default     = ["fgt"]
  description = "List of network tags assigned to FortiGate instance and to be open to all traffic."
}