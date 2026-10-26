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
  value       = azurerm_virtual_network.foundational_vnet.id
}

output "web_subnet_id" {
  description = "The ARM Resource ID of the web subnet"
  value       = azurerm_subnet.web_subnet.id
}

output "web_nsg_id" {
  description = "The ARM Resource ID of the web network security group"
  value       = azurerm_network_security_group.web_nsg.id
}

output "public_ip_address" {
  description = "The static public IP address provisioned for the web workload"
  value       = azurerm_public_ip.web_pip.ip_address
}

output "vm_name" {
  description = "The hostname of the deployed Linux VM"
  value       = azurerm_linux_virtual_machine.web_vm.name
}

output "ssh_command" {
  description = "Quick SSH connection string to connect to the VM"
  value       = "ssh -i ~/.ssh/id_rsa_azure ${var.admin_username}@${azurerm_public_ip.web_pip.ip_address}"
}