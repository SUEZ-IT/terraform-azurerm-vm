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

locals {
  virtual_machines_index = ["1", "2"]
}

module "availability_set" {
  source           = "../../modules/availability_set"
  cloudbundle_info = data.azurerm_resource_group.cloud_bundle_rg
  index            = 1
}

module "virtual_machine" {
  source = "../../modules/virtual_machine"
  providers = {
    azurerm.gallery = azurerm.gallery
  }
  for_each            = toset(local.virtual_machines_index)
  availability_set_id = module.availability_set.id
  cloudbundle_info    = data.azurerm_resource_group.cloud_bundle_rg
  index               = each.key
  size                = "Standard_D2s_v3"
  os_disk_type        = "Standard_LRS"
  role                = "example"
  ad_domain           = "green.local"
  os = {
    type    = "Rocky"
    version = "8"
  }
}