output "virtual_machine_name" {
  value       = local.vm_name
  description = "Virtual machine name"
}

output "virtual_machine_vnic_id" {
  value       = azurerm_network_interface.VmNic.id
  description = "Virtual network interface controller ID"
}

output "virtual_machine_id" {
  value       = var.os.type == "Windows" ? azurerm_windows_virtual_machine.virtual_machine[0].id : azurerm_linux_virtual_machine.virtual_machine[0].id
  description = "Virtual Machine ID"
}

output "kv_secret_login" {
  value       = azurerm_key_vault_secret.client_credentials_login.name
  description = "Login secret name inside your key vault"
}

output "kv_secret_password" {
  value       = azurerm_key_vault_secret.client_credentials_password.name
  description = "Password secret name inside your key vault"
}

output "cloudbundle_type" {
  value       = data.azurerm_resource_group.rg_target.tags["cloudbundle_type"]
  description = "Cloudbundle type where your resources are located"
}