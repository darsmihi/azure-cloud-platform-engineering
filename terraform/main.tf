
resource "azurerm_resource_group" "lab_rg" {
  name     = "rg-terraform-foundations"
  location = "centralindia"

  tags = {
    Environment = "Lab"
    Project     = "Project-A"
    ManagedBy   = "Terraform"
    Owner       = "Darshan Nair"
  }
} # <--- Closes after tags