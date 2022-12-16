resource "azurerm_virtual_machine_extension" "dependencyagent" {
  name                       = "DependencyAgent"
  virtual_machine_id         = var.os_type == "Windows" ? azurerm_windows_virtual_machine.virtual_machine[0].id : azurerm_linux_virtual_machine.virtual_machine[0].id
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = var.os_type == "Windows" ? "DependencyAgentWindows" : "DependencyAgentLinux"
  type_handler_version       = var.os_type == "Windows" ? "9.10" : "9.5"
  auto_upgrade_minor_version = "true"
  depends_on                 = [azurerm_managed_disk.virtual_machine_data_disk, azurerm_virtual_machine_data_disk_attachment.virtual_machine_data_disk_attachment, azurerm_virtual_machine_extension.vmagent]
}