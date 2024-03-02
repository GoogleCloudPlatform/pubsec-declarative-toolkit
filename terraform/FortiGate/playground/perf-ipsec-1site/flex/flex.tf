terraform {
  required_providers {
    fortiflexvm = {
      source  = "fortinetdev/fortiflexvm"
    }
  }
}
# Configure the FortiFlex provider by providing username and password for the API
# Credentials can be provided using variables, environment or pulled from secure storage (as here)
# NEVER STORE CREDENTIALS OR OTHER SENSITIVE INFORMATION IN YOUR CODE!

/*
# Get Flex credentials from secure secret vault
data "google_secret_manager_secret_version" "flex_user" {
  secret = var.flex_username_secret_name
}
data "google_secret_manager_secret_version" "flex_pass" {
  secret = var.flex_passwd_secret_name
}

# Configure FortiFlex provider
provider "fortiflexvm" {
    username = data.google_secret_manager_secret_version.flex_user.secret_data
    password = data.google_secret_manager_secret_version.flex_pass.secret_data
}
*/

# Find the proper config ID (many steps required):

## get program serial number...
data "fortiflexvm_programs_list" "all" {
}

## get all configs for the first program in the list
data "fortiflexvm_configs_list" "program0" {
    program_serial_number = data.fortiflexvm_programs_list.all.programs[0].serial_number
}

## get all serials for all FortiGate configs
data "fortiflexvm_entitlements_list" "program0" {
    for_each = toset([for config in try(data.fortiflexvm_configs_list.program0.configs, []) : format("%d", config.id) if contains(["FGT_VM_Bundle", "FGT_VM_LCS"], config.product_type)])
    config_id = each.value
}

## save map of serial=>config_id to locals
locals {
    serials_to_config = {for vm in flatten([for id,config in data.fortiflexvm_entitlements_list.program0 : config.entitlements]) : vm.serial_number=>vm.config_id}
}

# Get the FortiFlex token (set regenerate_token to true to make sure the token is not used)
# NOTE: leaving regenerate_token to true will regenerate token (even if not used) and change VM metadata on each terraform run
resource "fortiflexvm_entitlements_vm_token" "fgt" {
  for_each = toset(var.serials)
  config_id = local.serials_to_config[each.value]
  serial_number = each.value
  regenerate_token = true # If set as false, the provider will only provide the token and not regenerate it.

  lifecycle {
    ignore_changes = [regenerate_token]
  }
}
