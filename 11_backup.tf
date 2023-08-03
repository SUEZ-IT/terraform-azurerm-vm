resource "azurerm_backup_protected_vm" "vm_backup" {
  resource_group_name = data.azurerm_recovery_services_vault.vault_backup.resource_group_name
  recovery_vault_name = data.azurerm_recovery_services_vault.vault_backup.name
  source_vm_id        = var.os.type == "Windows" ? azurerm_windows_virtual_machine.virtual_machine[0].id : azurerm_linux_virtual_machine.virtual_machine[0].id
  backup_policy_id    = data.azurerm_backup_policy_vm.policy.id
  count               = var.backup == "true" && local.environment != "SBX" ? 1 : 0
  depends_on = [
    local.actual_virtual_machine,
    azurerm_virtual_machine_extension.vm_win_post_deploy_script,
    null_resource.validation_wallix_ad,
    null_resource.validation_wallix_ba,
    null_resource.validation_create_availability_set,
    null_resource.validation_availability_set
  ]
}