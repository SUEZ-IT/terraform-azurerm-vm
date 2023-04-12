terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      version               = "=3.50.0"
      configuration_aliases = [azurerm.gallery]
    }
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = "3.1.3"
    }
  }
}