resource "azurerm_availability_set" "avset" {
  name                = "avail-${local.app_name}-${local.environment}-${var.index}"
  resource_group_name = var.cloudbundle_info.name
  location            = local.location
}
