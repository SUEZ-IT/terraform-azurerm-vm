resource "azurerm_backup_protected_vm" "vm_backup" {
  resource_group_name = data.azurerm_recovery_services_vault.vault_backup.resource_group_name
  recovery_vault_name = data.azurerm_recovery_services_vault.vault_backup.name
  source_vm_id        = var.os.type == "Windows" ? azurerm_windows_virtual_machine.virtual_machine[0].id : azurerm_linux_virtual_machine.virtual_machine[0].id
  backup_policy_id    = data.azurerm_backup_policy_vm.policy.id
  count               = var.backup == "true" ? 1 : 0
}