resource "random_string" "client_login" {
  length  = 12
  special = false
  depends_on         = [null_resource.validation_wallix_ad,null_resource.validation_wallix_ba]
}

resource "random_password" "client_password" {
  length  = 16
  special = true
  depends_on         = [null_resource.validation_wallix_ad,null_resource.validation_wallix_ba]
}

resource "azurerm_key_vault_secret" "client_credentials_login" {
  name         = "${local.vm_name}-login"
  value        = random_string.client_login.result
  key_vault_id = data.azurerm_key_vault.cloudbundle_kv.id
  depends_on         = [null_resource.validation_wallix_ad,null_resource.validation_wallix_ba]
}

resource "azurerm_key_vault_secret" "client_credentials_password" {
  name         = "${local.vm_name}-password"
  value        = random_password.client_password.result
  key_vault_id = data.azurerm_key_vault.cloudbundle_kv.id
  depends_on         = [null_resource.validation_wallix_ad,null_resource.validation_wallix_ba]
}