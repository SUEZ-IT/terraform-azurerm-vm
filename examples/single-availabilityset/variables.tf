variable "resource_group_name" {
  type = string
}

variable "index" {
  type = number
}

variable "size" {
  type = string
}

variable "os_disk_type" {
  type = string
}

variable "role" {
  type = string
}

variable "ad_domain" {
  type = string
}

variable "os" {
  type = object({
    type    = string
    version = string
  })
}