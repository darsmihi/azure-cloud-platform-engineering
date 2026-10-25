
resource "azurerm_resource_group" "lab_rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = var.environment
    Project     = "Project-A"
    ManagedBy   = "Terraform"
    Owner       = var.owner
  }
} 

resource "azurerm_virtual_network" "foundational_vnet" {
  name                ="vnet-foundation"
  resource_group_name = azurerm_resource_group.lab_rg.name
  location            = var.location
  address_space       = var.vnet_address_space

  tags = {
    Environment = var.environment
    Project     = "Project-A"
    ManagedBy   = "Terraform"
    Owner       = var.owner
  }
}

# Workload Web Subnet
resource "azurerm_subnet" "web_subnet" {
  name                 = "snet-web"
  resource_group_name  = azurerm_resource_group.lab_rg.name
  virtual_network_name = azurerm_virtual_network.foundational_vnet.name
  address_prefixes     = var.subnet_web_prefix
}