resource "random_id" "randomId" {
  keepers = {
    resource_group = var.resource_group_name
  }

  byte_length = 8
  depends_on         = [null_resource.validation_wallix_ad,null_resource.validation_wallix_ba]
}
resource "azurerm_storage_account" "vm_sa" {
  name                     = "stodiag${random_id.randomId.hex}"
  resource_group_name      = var.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }
  depends_on         = [null_resource.validation_wallix_ad,null_resource.validation_wallix_ba]
}