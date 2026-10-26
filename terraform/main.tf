
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

  custom_data = base64encode(<<-EOF
    #!/bin/bash
    set -euo pipefail
    
    # Update package index and install Nginx
    apt-get update -y
    apt-get install -y nginx

    # Ensure Nginx is enabled and active
    systemctl enable --now nginx

    # Deploy custom platform engineering landing page
    cat <<PAGE > /var/www/html/index.html
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <title>Azure Cloud Platform Engineering</title>
      <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; text-align: center; padding: 60px 20px; background-color: #0e1117; color: #e6edf3; }
        .card { background-color: #161b22; border: 1px solid #30363d; border-radius: 8px; max-width: 650px; margin: 0 auto; padding: 40px; box-shadow: 0 4px 12px rgba(0,0,0,0.5); }
        h1 { color: #58a6ff; margin-bottom: 8px; }
        p.subtitle { color: #8b949e; font-size: 1.1rem; margin-top: 0; }
        .meta { text-align: left; background-color: #0d1117; padding: 15px 20px; border-radius: 6px; font-family: monospace; font-size: 0.95rem; line-height: 1.6; border: 1px solid #21262d; margin-top: 25px; }
        .status-badge { display: inline-block; padding: 4px 10px; background-color: #238636; color: white; border-radius: 20px; font-size: 0.85rem; font-weight: bold; }
      </style>
    </head>
    <body>
      <div class="card">
        <span class="status-badge">Automated Deployment Active</span>
        <h1>Project A: Infrastructure as Code</h1>
        <p class="subtitle">Azure Cloud Platform & DevOps Engineering</p>
        <div class="meta">
          <strong>Orchestration:</strong> Terraform (Remote State Backend)<br>
          <strong>Host:</strong> vm-web-lab<br>
          <strong>Compute SKU:</strong> Standard_DC1s_v3 (Zone 3)<br>
          <strong>Location:</strong> Central India<br>
          <strong>Bootstrap Agent:</strong> Cloud-Init (Nginx auto-provisioned)
        </div>
      </div>
    </body>
    </html>
    PAGE
      EOF
    )

  tags = {
    Environment = var.environment
    Project     = "Project-A"
    ManagedBy   = "Terraform"
    Owner       = var.owner
  }
}

