output "virtual_machine_name" {
  value       = local.vm_name
  description = "Virtual machine name."
}

output "virtual_machine_vnic_id" {
  value       = try(azurerm_network_interface.nic.id, null)
  description = "Virtual network interface controller ID."
}

output "virtual_machine_id" {
  value       = var.os.type == "Windows" ? try(azurerm_windows_virtual_machine.virtual_machine[0].id, null) : try(azurerm_linux_virtual_machine.virtual_machine[0].id, null)
  description = "Virtual Machine ID."
}

output "kv_name" {
  value       = var.create_default_keyvault ? try(azurerm_key_vault.default_kv[0].name, null) : try(data.azurerm_key_vault.cloudbundle_kv[0].name, null)
  description = "Credentials Azure key vault Name."
}

output "kv_secret_login" {
  value       = try(azurerm_key_vault_secret.client_credentials_login.name, null)
  description = "Login secret name inside the Cloud Bundle key vault."
}

output "kv_secret_password" {
  value       = try(azurerm_key_vault_secret.client_credentials_password.name, null)
  description = "Password secret name inside the Cloud Bundle key vault."
}


output "AlertingInformationVmaas" {
  value = <<EOT
    ⚠️  WARNING: Dear VMaaS user, the implementation of the new Hosting Policy requires that any new virtual machine creation obtain an exemption.

    Please refer to the Hosting Policy portal on the IT Architecture Reference site.

    To request an exemption, contact: dl-glob-it-gis-gts-ats@suez.com.

    ➡️  You must submit your VM exemptions BEFORE running the VMaaS Terraform module.

    — The VMaaS Team
    EOT

  description = "Message for VMaaS end users"
}
