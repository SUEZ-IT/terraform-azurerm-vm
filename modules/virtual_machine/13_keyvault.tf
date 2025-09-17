resource "random_string" "client_login" {
  length     = 12
  special    = false
  depends_on = [null_resource.validation_bastion_ad, null_resource.validation_bastion_ba]
}

resource "random_password" "client_password" {
  length           = 16
  special          = true
  min_special      = 1
  override_special = "!@#$%&*()-=+[]{}"
  lower            = true
  min_lower        = 1
  upper            = true
  min_upper        = 1
  number           = true
  min_numeric      = 1
  depends_on       = [null_resource.validation_bastion_ad, null_resource.validation_bastion_ba]
}

resource "azurerm_key_vault" "default_kv" {
  count                           = var.create_default_keyvault ? 1 : 0
  name                            = lower("kv${local.app_name}${local.environment}")
  location                        = var.cloudbundle_info.location
  resource_group_name             = var.cloudbundle_info.name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = "standard"
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  enable_rbac_authorization       = true
  public_network_access_enabled   = true
  soft_delete_retention_days      = 7

  lifecycle {
    ignore_changes = [public_network_access_enabled]
  }

}

resource "azurerm_private_endpoint" "default_kv_pe" {
  count               = var.create_default_keyvault ? 1 : 0
  name                = "pe-${azurerm_key_vault.default_kv[0].name}"
  location            = azurerm_key_vault.default_kv[0].location
  resource_group_name = azurerm_key_vault.default_kv[0].resource_group_name
  subnet_id           = data.azurerm_subnet.vmsubnet.id

  private_service_connection {
    name                           = "psc_${azurerm_key_vault.default_kv[0].name}"
    private_connection_resource_id = azurerm_key_vault.default_kv[0].id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  lifecycle {
    ignore_changes = [
      private_dns_zone_group
    ]
  }

}

resource "azapi_update_resource" "default_kv_enable_access" {
  count       = var.create_default_keyvault ? 1 : 0
  type        = "Microsoft.KeyVault/vaults@2023-07-01"
  resource_id = azurerm_key_vault.default_kv[0].id

  body = jsonencode({
    properties = {
      publicNetworkAccess = "Enabled"
    }
  })

  lifecycle {
    ignore_changes = all
  }

  depends_on = [azurerm_private_endpoint.default_kv_pe]

}

resource "azurerm_key_vault_secret" "client_credentials_login" {
  name         = "${local.vm_name}-login"
  value        = random_string.client_login.result
  key_vault_id = var.create_default_keyvault ? azurerm_key_vault.default_kv[0].id : data.azurerm_key_vault.cloudbundle_kv[0].id
  depends_on   = [null_resource.validation_bastion_ad, null_resource.validation_bastion_ba, azurerm_private_endpoint.default_kv_pe, azapi_update_resource.default_kv_enable_access]
}

resource "azurerm_key_vault_secret" "client_credentials_password" {
  name         = "${local.vm_name}-password"
  value        = random_password.client_password.result
  key_vault_id = var.create_default_keyvault ? azurerm_key_vault.default_kv[0].id : data.azurerm_key_vault.cloudbundle_kv[0].id
  depends_on   = [null_resource.validation_bastion_ad, null_resource.validation_bastion_ba, azurerm_private_endpoint.default_kv_pe, azapi_update_resource.default_kv_enable_access]
}


resource "azapi_update_resource" "default_kv_disable_access" {
  count       = var.create_default_keyvault ? 1 : 0
  type        = "Microsoft.KeyVault/vaults@2023-07-01"
  resource_id = azurerm_key_vault.default_kv[0].id

  body = jsonencode({
    properties = {
      publicNetworkAccess = "Disabled"
    }
  })

  depends_on = [azurerm_key_vault_secret.client_credentials_password, azurerm_key_vault_secret.client_credentials_login]

}
