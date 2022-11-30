resource "azurerm_virtual_machine_extension" "vmagent" {
  name                 = "vmagent"
  virtual_machine_id   = var.os_type == "Windows" ? azurerm_windows_virtual_machine.virtual_machine[0].id : azurerm_linux_virtual_machine.virtual_machine[0].id
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = var.os_type == "Windows" ? "MicrosoftMonitoringAgent" : "OmsAgentForLinux"
  type_handler_version = var.os_type == "Windows" ? "1.0" : "1.14"
  
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
}
