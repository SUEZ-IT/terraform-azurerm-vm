terraform {
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

provider "azurerm" {
  skip_provider_registration = true
  alias                      = "gallery"
  subscription_id            = sort(data.azurerm_subscriptions.osfactory.subscriptions.*.subscription_id)[0]
  features {}
}

data "azurerm_subscriptions" "osfactory" {
  display_name_prefix = "Suez IT OSFactory"
}

data "azurerm_resource_group" "cloud_bundle_rg" {
  name = "RG_NAME" # To be updated
}

module "virtual_machine" {
  source = "../../modules/virtual_machine"
  providers = {
    azurerm.gallery = azurerm.gallery
  }
  cloudbundle_info = data.azurerm_resource_group.cloud_bundle_rg
  index            = 123
  size             = "Standard_D2s_v3"
  os_disk_type     = "Standard_LRS"
  role             = "example"
  ad_domain        = "DomainName"
  os = {
    type    = "Redhat"
    version = "9"
  }
}