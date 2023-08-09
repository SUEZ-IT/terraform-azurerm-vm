resource_group_name = "rg-example-dev"
index               = 123
size                = "Standard_D2s_v3"
os_disk_type        = "Standard_LRS"
role                = "example-dev"
ad_domain           = "green.local"
os = {
  type    = "Windows"
  version = "2022"
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