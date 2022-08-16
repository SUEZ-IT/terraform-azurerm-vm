provider "azurerm" {
  skip_provider_registration = true
  features {}
  subscription_id = var.gallery_subscription_id
  alias           = "gallery"
}