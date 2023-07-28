resource "azurerm_monitor_data_collection_rule_association" "datacr" {
  name                    = local.managed_by_cap ? "managed-dcra" : "unmanaged-dcra"
  target_resource_id      = var.os.type == "Windows" ? azurerm_windows_virtual_machine.virtual_machine[0].id : azurerm_linux_virtual_machine.virtual_machine[0].id
  data_collection_rule_id = data.azurerm_monitor_data_collection_rule.monitordatacolrule.id
  depends_on = [
    azurerm_windows_virtual_machine.virtual_machine[0],
    azurerm_linux_virtual_machine.virtual_machine[0],
    azurerm_virtual_machine_extension.vmagentama,
    null_resource.validation_wallix_ad,
    null_resource.validation_wallix_ba,
    null_resource.validation_create_availability_set,
    null_resource.validation_availability_set
  ]
}
