terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      version               = "~> 3.50.0"
      configuration_aliases = [azurerm.gallery]
    }
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = "~> 3.1.3"
    }
    null = {
      source  = "registry.terraform.io/hashicorp/null"
      version = "~> 3.2.1"
    }
    archive = {
      source  = "registry.terraform.io/hashicorp/archive"
      version = "~> 2.4.0"
    }
    template = {
      source  = "registry.terraform.io/hashicorp/template"
      version = "~> 2.2.0"
    }
  }
}