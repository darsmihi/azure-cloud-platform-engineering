
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
