locals {
  environment = lower(var.cloudbundle_info.tags["environment"])
  app_name    = lower(var.cloudbundle_info.tags["app_name"])
  location    = lower(var.cloudbundle_info.location)
}