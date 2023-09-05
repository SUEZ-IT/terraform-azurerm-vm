variable "cloudbundle_info" {
  description = <<EOF
  **Cloud Bundle target datasource.**
  - Example:
  ```
  data "azurerm_resource_group" "main" {
    name = "rg-RG_NAME-dev"
  }

  module "availability_set" {
    ...
    cloudbundle_info = data.azurerm_resource_group.main
  }
  ```
  EOF
}

variable "index" {
  type        = number
  description = <<EOF
  **Availability Set index (used to determine the Availability Set name).**
  - Constraint:
  Valid values for index are between [001..999]
  - Example:
  ```
  index = 001
  ```
  EOF

  validation {
    condition     = var.index >= 1 && var.index <= 999 && floor(var.index) == var.index
    error_message = "Valid values for var: index are (between 1 to 999)."
  }
}