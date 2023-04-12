data "azurerm_recovery_services_vault" "vault_backup" {
  name                = "${local.managed_by_cap == "yes" || local.managed_by_cap == "true" ? "rsv-${local.environment}${local.subscription_digit}-${local.code_msp[0]}-msp-${local.subscription_digit}" : "rsv-${local.app_name}-${local.environment}" }"
  resource_group_name = "${local.managed_by_cap == "yes" || local.managed_by_cap == "true" ? data.azurerm_resource_group.inframsp[0].name : var.resource_group_name}"
}
data "azurerm_backup_policy_vm" "policy" {
  name                = "DefaultPolicy"
  recovery_vault_name = data.azurerm_recovery_services_vault.vault_backup.name
  resource_group_name = data.azurerm_recovery_services_vault.vault_backup.resource_group_name
}

data "azurerm_key_vault" "cloudbundle_kv" {
  name                = "kv${local.app_name}${local.environment}"
  resource_group_name = var.resource_group_name
}

data "azurerm_log_analytics_workspace" "cloudbundle_la" {
  name                = "${local.managed_by_cap == "yes" || local.managed_by_cap == "true" ? "log-${local.environment}${local.subscription_digit}-${local.code_msp[0]}-msp-${local.subscription_digit}" :"log-${local.app_name}-${local.environment}-default-01"}"
  resource_group_name = "${local.managed_by_cap == "yes" || local.managed_by_cap == "true" ? data.azurerm_resource_group.inframsp[0].name : var.resource_group_name}"
}

data "azurerm_subnet" "vmsubnet" {
  resource_group_name  = "rg-infracb-network-${local.location}-${local.environment}"
  virtual_network_name = "vnet-${local.environment}${local.subscription_digit}-${local.location}"
  name                 =  var.subnet != "" ? var.subnet : "snet-${local.app_name}-main-${local.environment}"
}

data "azurerm_resource_group" "rg_target" {
  name = var.resource_group_name
}

data "azurerm_shared_image" "osfactory_image" {
  provider            = azurerm.gallery
  name                = local.osfactory_image_name[0]
  gallery_name        = local.gallery_name
  resource_group_name = local.gallery_resource_group_name
}

data "azurerm_resource_group" "inframsp" {
  count ="${local.managed_by_cap == "yes" || local.managed_by_cap == "true" ? 1 : 0}" 
  name = "rg-inframsp-monitoring-${local.location_msp[0]}-${local.environment}${local.subscription_digit}"
}

data "azurerm_subscription" "current" {
}

data "azurerm_monitor_data_collection_rule" "monitordatacolrule" {
  count = "${local.managed_by_cap == "yes" || local.managed_by_cap == "true" ?1:0}"
  name                = local.datacollectionrulename
  resource_group_name = data.azurerm_recovery_services_vault.vault_backup.resource_group_name
}

