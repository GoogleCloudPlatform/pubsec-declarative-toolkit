variable "ver" {
	type = string
	description = "FortiGate firmware version, eg. \"7.4.1\"."
}

variable "lic" {
	type = string
	default = "payg"
	description = "Licensing type. Allowed values are \"payg\" (default) and \"byol\"."
	validation {
		condition = contains(["payg", "byol"], var.lic)
		error_message = "Licensing can be either 'payg' or 'byol' (default: 'payg'). For FortiFlex use 'byol'"
	}
}

variable "arch" {
	type = string
	default = "x64"
	description = "Architecture type. Allowed values are \"arm\" or \"x64\" (default)."
	validation {
		condition = contains(["arm", "x64"], var.arch)
		error_message = "Architecture must be either 'arm' or 'x64' (default: 'x64')"
	}
}
