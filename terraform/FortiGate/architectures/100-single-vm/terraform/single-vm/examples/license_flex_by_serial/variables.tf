variable "serial_number" {
    type = string
    description = "FortiGate VM serial number in FortiFlex"
}

variable "flex_username_secret_name" {
    type = string
    description = "Name of the secret in Secret Manager storing the FortiFlex API username"
}

variable "flex_passwd_secret_name" {
    type = string
    description = "Name of the secret in Secret Manager storing the FortiFlex API password"
}