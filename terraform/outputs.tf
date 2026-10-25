output "resource_group_id" {
  description = "The ARM Resource ID of the deployed resource group"
  value       = azurerm_resource_group.lab_rg.id
}

output "resource_group_name" {
  description = "The name of the deployed resource group"
  value       = azurerm_resource_group.lab_rg.name
}

output "vnet_id" {
  description = "The ARM Resource ID of the virtual network"
  value       = azurerm_virtual_network.foundation_vnet.id
}

output "web_subnet_id" {
  description = "The ARM Resource ID of the web subnet"
  value       = azurerm_subnet.web_subnet.id
}