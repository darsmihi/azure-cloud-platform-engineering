
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

# Standard Static Public IP
resource "azurerm_public_ip" "web_pip" {
  name                = "pip-web-vm"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = var.environment
    Project     = "Project-A"
    ManagedBy   = "Terraform"
    Owner       = var.owner
  }
}

# Network Interface Card (NIC) connecting the VM to snet-web & Public IP
resource "azurerm_network_interface" "web_nic" {
  name                = "nic-web-vm"
  location            = azurerm_resource_group.lab_rg.location
  resource_group_name = azurerm_resource_group.lab_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_pip.id
  }

  tags = {
    Environment = var.environment
    Project     = "Project-A"
    ManagedBy   = "Terraform"
    Owner       = var.owner
  }
}

# Ubuntu 24.04 LTS Compute Instance
resource "azurerm_linux_virtual_machine" "web_vm" {
  name                  = "vm-web-lab"
  computer_name         = "vm-web-lab"
  location              = azurerm_resource_group.lab_rg.location
  resource_group_name   = azurerm_resource_group.lab_rg.name
  size                  = var.vm_size
  zone                  = "3"
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.web_nic.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = {
    Environment = var.environment
    Project     = "Project-A"
    ManagedBy   = "Terraform"
    Owner       = var.owner
  }
}

