output "tokens" {
    value = [for lic in fortiflexvm_entitlements_vm_token.fgt : lic.token ]
}