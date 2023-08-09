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

module "virtual_machine" {
  source = "../../modules/virtual_machine"
  providers = {
    azurerm.gallery = azurerm.gallery
  }
  cloudbundle_info = data.azurerm_resource_group.main
  index            = var.index
  size             = var.size
  os_disk_type     = var.os_disk_type
  role             = var.role
  ad_domain        = var.ad_domain
  os = {
    type    = var.os.type
    version = var.os.version
  }
  data_disk = var.data_disk
}