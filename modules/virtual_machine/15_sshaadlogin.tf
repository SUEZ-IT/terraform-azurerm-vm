resource "azurerm_virtual_machine_extension" "aad_ssh_login" {
  count = ((local.environment == "dev") || (local.environment == "rec")) && var.os.type != "Windows" ? 1 : 0

  name                       = "AADSSHLoginForLinux"
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADSSHLoginForLinux"
  type_handler_version       = "1.0"
  virtual_machine_id         = azurerm_linux_virtual_machine.virtual_machine[0].id
  auto_upgrade_minor_version = true

  depends_on = [azurerm_managed_disk.virtual_machine_data_disk, azurerm_virtual_machine_data_disk_attachment.virtual_machine_data_disk_attachment, null_resource.validation_bastion_ad, null_resource.validation_bastion_ba]
}