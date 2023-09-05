resource "azurerm_virtual_machine_extension" "agentama" {
  name                       = var.os.type == "Windows" ? "AzureMonitorWindowsAgent" : "AzureMonitorLinuxAgent"
  virtual_machine_id         = var.os.type == "Windows" ? azurerm_windows_virtual_machine.virtual_machine[0].id : azurerm_linux_virtual_machine.virtual_machine[0].id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = var.os.type == "Windows" ? "AzureMonitorWindowsAgent" : "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = "true"
  depends_on                 = [azurerm_managed_disk.virtual_machine_data_disk, azurerm_virtual_machine_data_disk_attachment.virtual_machine_data_disk_attachment, azurerm_windows_virtual_machine.virtual_machine[0], azurerm_linux_virtual_machine.virtual_machine[0], null_resource.validation_wallix_ad, null_resource.validation_wallix_ba, azurerm_virtual_machine_extension.vm_win_post_deploy_script]
}
