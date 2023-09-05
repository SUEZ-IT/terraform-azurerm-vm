output "id" {
  value       = azurerm_availability_set.avset.id
  description = "Availability set ID."
}

output "name" {
  value       = azurerm_availability_set.avset.name
  description = "Availability set name."
}