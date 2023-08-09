resource_group_name = "rg-example-dev"
size                = "Standard_D2s_v3"
os_disk_type        = "Standard_LRS"
role                = "example-dev"
ad_domain           = "green.local"
os = {
  type    = "Rocky"
  version = "8"
}