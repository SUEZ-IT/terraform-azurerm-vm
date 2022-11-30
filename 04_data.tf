data "azurerm_recovery_services_vault" "vault_backup" {
  name                = "rsv-${local.app_name}-${local.environment}"
  resource_group_name = var.resource_group_name

}
data "azurerm_backup_policy_vm" "policy" {
  name                = "DefaultPolicy"
  recovery_vault_name = data.azurerm_recovery_services_vault.vault_backup.name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault" "cloudbundle_kv" {
  name                = "kv${local.app_name}${local.environment}"
  resource_group_name = var.resource_group_name
}

data "azurerm_log_analytics_workspace" "cloudbundle_la" {
  name                = "log-${local.app_name}-${local.environment}-default-01"
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "vmsubnet" {
  resource_group_name  = "rg-infracb-network-${local.location}-${local.environment}"
  virtual_network_name = "vnet-${local.environment}01-${local.location}"
  name                 = "snet-${local.app_name}-${lookup(local.cloudbundle_type, data.azurerm_resource_group.rg_target.tags["cloudbundle_type"])}-${local.environment}"
}

data "azurerm_resource_group" "rg_target" {
  name = var.resource_group_name
}

data "azurerm_shared_image" "osfactory_image" {
  provider            = azurerm.gallery
  name                = local.osfactory_image_name
  gallery_name        = local.gallery_name
  resource_group_name = local.gallery_resource_group_name
}

