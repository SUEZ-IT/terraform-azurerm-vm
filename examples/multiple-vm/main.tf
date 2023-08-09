terraform {
  required_version = ">= 1.0.0"
  backend "local" {
  }
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
  name = var.resource_group_name
}

locals {
  virtual_machines_index = ["1", "2"]
}
module "virtual_machine" {
  source = "../../modules/virtual_machine"
  providers = {
    azurerm.gallery = azurerm.gallery
  }
  for_each         = toset(local.virtual_machines_index)
  cloudbundle_info = data.azurerm_resource_group.main
  index            = each.key
  size             = var.size
  os_disk_type     = var.os_disk_type
  role             = var.role
  ad_domain        = var.ad_domain
  os = {
    type    = var.os.type
    version = var.os.version
  }
}