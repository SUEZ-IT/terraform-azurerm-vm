data "azurerm_subnet" "vmsubnet" {
  resource_group_name  = "rg-infracb-network-${local.location}-${local.environment}"
  virtual_network_name = "vnet-${local.environment}01-${local.location}"
  name                 = "snet-${local.app_name}-ce-${local.environment}"
}

data "azurerm_resource_group" "rg_target" {
  name      = var.resource_group_name
}

data "azurerm_shared_image" "osfactory_image" {
  provider            = azurerm.gallery
  name                = local.osfactory_image_name
  gallery_name        = local.gallery_name
  resource_group_name = local.gallery_resource_group_name
}

locals {
  vm_name                     = "${substr(data.azurerm_resource_group.rg_target.tags["environment"], 0, 1)}${data.azurerm_resource_group.rg_target.tags["guid"]}${var.index}"
  environment                 = lower(data.azurerm_resource_group.rg_target.tags["environment"])
  app_name                    = lower(data.azurerm_resource_group.rg_target.tags["app_name"])
  location                    = lower(data.azurerm_resource_group.rg_target.location)
  osfactory_image_name        = var.os_type == "Windows" ? "WindowsServer2019Datacenter" : "UbuntuServer1804"
  gallery_name                = "gal_infra_os_factory"
  gallery_resource_group_name = "rg-infra-compute-gallery-northeurope"
  virtual_machine_tags = {
    role                       = var.role
    environment                = local.environment
    reboot_hebdo               = var.reboot_hebdo
    availability               = var.availability
    classification             = var.classification
    os_type                    = var.os_type
    CloudGuard-FusionInventory = var.tags_cloudguard["fusion_inventory"]
  }
}

resource "azurerm_network_interface" "VmNic" {
  name                = "nic-${local.vm_name}"
  location            = local.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "nic-${local.vm_name}-conf"
    subnet_id                     = data.azurerm_subnet.vmsubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "virtual_machine" {
  count                 = var.os_type == "Windows" ? 1 : 0
  name                  = local.vm_name
  location              = local.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = ["${azurerm_network_interface.VmNic.id}"]
  size                  = var.size
  admin_username        = azurerm_key_vault_secret.client_credentials_login.value
  admin_password        = azurerm_key_vault_secret.client_credentials_password.value
  tags                  = local.virtual_machine_tags
  source_image_id       = data.azurerm_shared_image.osfactory_image.id
  os_disk {
    name                 = "${local.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }
}

resource "azurerm_linux_virtual_machine" "virtual_machine" {
  count                           = var.os_type == "Linux" ? 1 : 0
  name                            = local.vm_name
  location                        = local.location
  resource_group_name             = var.resource_group_name
  network_interface_ids           = ["${azurerm_network_interface.VmNic.id}"]
  size                            = var.size
  admin_username                  = azurerm_key_vault_secret.client_credentials_login.value
  admin_password                  = azurerm_key_vault_secret.client_credentials_password.value
  disable_password_authentication = false
  tags                            = local.virtual_machine_tags
  source_image_id                 = data.azurerm_shared_image.osfactory_image.id
  os_disk {
    name                 = "${local.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }
}