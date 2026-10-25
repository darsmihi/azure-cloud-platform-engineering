
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

# Web Tier Network Security group
resource "azurerm_network_security_group" "web_nsg" {
  name                = "nsg-web"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name


  # Allow Public Inbound HTTP
  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow Restricted Inbound SSH (Workstation Only)
  security_rule {
    name                       = "Allow-SSH-Restricted"
    priority                   = 210
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.admin_source_ip
    destination_address_prefix = "*"
  }

  tags = {
    Environment = var.environment
    Project     = "Project-A"
    ManagedBy   = "Terraform"
    Owner       = var.owner
  }
}
  resource "azurerm_subnet_network_security_group_association" "web_nsg_assoc" {
  subnet_id                 = azurerm_subnet.web_subnet.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}