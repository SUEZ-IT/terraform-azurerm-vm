terraform {
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  skip_provider_registration = true
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}
provider "azurerm" {
  skip_provider_registration = true
  alias                      = "gallery"
  subscription_id            = "d980e79b-480a-4282-a6b5-27e052e79f4b"
  features {}
}

data "azurerm_resource_group" "main" {
  name = "RG_NAME" # To be updated
}

locals {
  virtual_machines_index = ["1", "2"]
}

module "availability_set" {
  source           = "../../modules/availability_set"
  cloudbundle_info = data.azurerm_resource_group.main
  index            = 1
}

module "virtual_machine" {
  source = "../../modules/virtual_machine"
  providers = {
    azurerm.gallery = azurerm.gallery
  }
  for_each            = toset(local.virtual_machines_index)
  availability_set_id = module.availability_set.id
  cloudbundle_info    = data.azurerm_resource_group.main
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