resource "azurerm_monitor_data_collection_rule_association" "datacr" {
  count = "${local.managed_by_cap == "yes" || local.managed_by_cap == "true" ?1:0}"
  name                    = "managed-dcra"
  target_resource_id          = var.os.type == "Windows" ? azurerm_windows_virtual_machine.virtual_machine[0].id : azurerm_linux_virtual_machine.virtual_machine[0].id
  data_collection_rule_id = data.azurerm_monitor_data_collection_rule.monitordatacolrule[0].id
  depends_on = [
    azurerm_windows_virtual_machine.virtual_machine[0],
    azurerm_linux_virtual_machine.virtual_machine[0],
    azurerm_virtual_machine_extension.vmagent,
    azurerm_virtual_machine_extension.vmagentama
  ]
}