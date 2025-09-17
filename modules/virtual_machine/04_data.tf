data "azurerm_client_config" "current" {}

data "azurerm_recovery_services_vault" "vault_backup" {
  name                = local.vault_backup_name
  resource_group_name = local.vault_backup_rg_name
}

data "azurerm_backup_policy_vm" "policy" {
  name                = local.default_backup_policy_name
  recovery_vault_name = data.azurerm_recovery_services_vault.vault_backup.name
  resource_group_name = data.azurerm_recovery_services_vault.vault_backup.resource_group_name
}

data "azurerm_key_vault" "cloudbundle_kv" {
  count               = var.create_default_keyvault ? 0 : 1
  name                = var.keyvault_name
  resource_group_name = var.cloudbundle_info.name
  lifecycle {
    precondition {
      condition     = (var.keyvault_name != "")
      error_message = "A value for the parameter`keyvault_name` must be provided to the module when `create_default_keyvault` is set to false "
    }
  }
}

data "azurerm_log_analytics_workspace" "cloudbundle_la" {
  name                = local.managed_by_cap ? "log-${local.environment}${local.subscription_digit}-${local.code_msp[0]}-msp-${local.subscription_digit}" : "log-${local.app_name}-${local.environment}-default-01"
  resource_group_name = local.managed_by_cap ? data.azurerm_resource_group.inframsp[0].name : var.cloudbundle_info.name
}

data "azurerm_subnet" "vmsubnet" {
  resource_group_name  = "rg-infracb-network-${local.location}-${local.environment}"
  virtual_network_name = "vnet-${local.environment}${local.subscription_digit}-${local.location}"
  name                 = var.subnet != "" ? var.subnet : "snet-${local.app_name}-main-${local.environment}"
}

data "azurerm_shared_image" "osfactory_image" {
  provider            = azurerm.gallery
  name                = local.osfactory_image_name[0]
  gallery_name        = local.gallery_name
  resource_group_name = local.gallery_resource_group_name
}

data "azurerm_resource_group" "inframsp" {
  count = local.managed_by_cap ? 1 : 0
  name  = "rg-inframsp-monitoring-${local.location_msp[0]}-${local.environment}${local.subscription_digit}"
}

data "azurerm_subscription" "current" {
}

data "template_file" "win_post_deploy_scripts_template" {
  count = (var.os.type == "Windows" ? length(local.win_post_deploy_scripts_path) : 0)

  template = file(element(local.win_post_deploy_scripts_path, count.index))
}

data "archive_file" "win_post_deploy_scripts_zipped" {
  count       = (var.os.type == "Windows" ? 1 : 0)
  type        = "zip"
  output_path = "${path.module}/scripts/win_post_deploy.zip"

  dynamic "source" {
    for_each = zipmap(range(length(local.win_post_deploy_scripts_path)), local.win_post_deploy_scripts_path)
    content {
      content  = data.template_file.win_post_deploy_scripts_template[source.key].rendered
      filename = reverse(split("/", source.value))[0]
    }
  }
}

