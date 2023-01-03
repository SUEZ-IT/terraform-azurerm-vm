resource "azurerm_virtual_machine_extension" "vmagent" {
  count                = local.osfactory_image_name[0] == "UbuntuServer2204" ? 0 : 1
  name                 = "vmagent"
  virtual_machine_id   = var.os.type == "Windows" ? azurerm_windows_virtual_machine.virtual_machine[0].id : azurerm_linux_virtual_machine.virtual_machine[0].id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = var.os.type == "Windows" ? "MicrosoftMonitoringAgent" : "OmsAgentForLinux"
  type_handler_version = var.os.type == "Windows" ? "1.0" : "1.14"

  auto_upgrade_minor_version = "true"

  settings           = <<SETTINGS
    {
      "workspaceId": "${data.azurerm_log_analytics_workspace.cloudbundle_la.workspace_id}"
    }
SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
    {
      "workspaceKey": "${data.azurerm_log_analytics_workspace.cloudbundle_la.primary_shared_key}"
    }
PROTECTED_SETTINGS
  depends_on         = [azurerm_managed_disk.virtual_machine_data_disk, azurerm_virtual_machine_data_disk_attachment.virtual_machine_data_disk_attachment]
}
