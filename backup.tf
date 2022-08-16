data "azurerm_recovery_services_vault" "vault_backup" {
  name                = "rsv-${local.app_name}-${local.environment}"
  resource_group_name = var.resource_group_name

}
data "azurerm_backup_policy_vm" "policy" {
  name                = "DefaultPolicy"
  recovery_vault_name = data.azurerm_recovery_services_vault.vault_backup.name
  resource_group_name = var.resource_group_name
}
resource "azurerm_backup_protected_vm" "vm_backup" {
  resource_group_name = var.resource_group_name
  recovery_vault_name = data.azurerm_recovery_services_vault.vault_backup.name
  source_vm_id        = var.os_type == "Windows" ? azurerm_windows_virtual_machine.virtual_machine[0].id : azurerm_linux_virtual_machine.virtual_machine[0].id
  backup_policy_id    = data.azurerm_backup_policy_vm.policy.id
  count               = var.backup == "true" ? 1 : 0
}