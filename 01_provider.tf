provider "azurerm" {
  skip_provider_registration = true
  alias                      = "gallery"
  subscription_id            = sort(data.azurerm_subscriptions.osfactory.subscriptions.*.subscription_id)[0]
  features {}
}

data "azurerm_subscriptions" "osfactory" {
  display_name_prefix = "Suez IT OSFactory"
}