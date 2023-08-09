resource "azurerm_virtual_machine_extension" "dependencyagent" {
  count                      = contains(["UbuntuServer2204", "RockyLinux8", "RedHatEnterprise9"], local.osfactory_image_name[0]) ? 0 : 1
  name                       = "DependencyAgent"
  virtual_machine_id         = var.os.type == "Windows" ? azurerm_windows_virtual_machine.virtual_machine[0].id : azurerm_linux_virtual_machine.virtual_machine[0].id
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = var.os.type == "Windows" ? "DependencyAgentWindows" : "DependencyAgentLinux"
  type_handler_version       = var.os.type == "Windows" ? "9.10" : "9.5"
  auto_upgrade_minor_version = "true"
  depends_on                 = [azurerm_managed_disk.virtual_machine_data_disk, azurerm_virtual_machine_data_disk_attachment.virtual_machine_data_disk_attachment, azurerm_virtual_machine_extension.agentama, null_resource.validation_wallix_ad, null_resource.validation_wallix_ba]
}