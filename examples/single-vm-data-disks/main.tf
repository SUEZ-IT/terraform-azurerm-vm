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

module "virtual_machine" {
  source = "../../modules/virtual_machine"
  providers = {
    azurerm.gallery = azurerm.gallery
  }
  cloudbundle_info = data.azurerm_resource_group.main
  index            = 123
  size             = "Standard_D2s_v3"
  os_disk_type     = "Standard_LRS"
  role             = "example"
  ad_domain        = "green.local"
  os = {
    type    = "Ubuntu"
    version = "2204"
  }
  data_disk = {
    "1" = {
      lun  = 1
      size = 5
      type = "Standard_LRS"
    }
    "2" = {
      lun  = 2
      size = 10
      type = "Standard_LRS"
    }
  }
}