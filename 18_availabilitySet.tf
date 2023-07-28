
resource "random_string" "random_string" {
  length  = 3
  special = false
  upper   = false
  number  = true

  override_special = "abcdefghijklmnopqrstuvwxyz1234567890"
}
resource "azurerm_availability_set" "availabilityset" {
  count               = var.create_availability_set && var.availability_zone == "" && var.availability_set_name == "" ? 1 : 0
  name                = "avail-${local.app_name}-${local.environment}-${random_string.random_string.result}"
  resource_group_name = data.azurerm_resource_group.rg_target.name
  location            = data.azurerm_resource_group.rg_target.location
  depends_on          = [null_resource.validation_wallix_ad, null_resource.validation_wallix_ba, null_resource.validation_create_availability_set, null_resource.validation_availability_set]
}