terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-foundations"
    storage_account_name = "tfstate796080" # Must be globally unique
    container_name       = "tfstate"
    key                  = "terraform.tfstate" # The path/name of your state file
    # Recommended for secure, keyless authentication
    use_azuread_auth     = true
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}