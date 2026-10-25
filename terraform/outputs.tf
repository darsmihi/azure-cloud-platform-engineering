output "resource_group_id" {
  description = "The ARM Resource ID of the deployed resource group"
  value       = azurerm_resource_group.lab_rg.id
}

output "resource_group_name" {
  description = "The name of the deployed resource group"
  value       = azurerm_resource_group.lab_rg.name
}