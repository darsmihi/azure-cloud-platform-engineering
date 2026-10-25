variable "resource_group_name" {
    description = "Name of the base foundation resource group"
    type        = string
    default     = "rg-terraform-foundations"
}

variable "location" {
    description = "Azure region for resource deployment"
    type        = string
    default     = "centralindia"
}

variable "environment" {
    description = "Target deployment environment tag"
    type        = string
    default     = "Lab"
}

variable "owner" {
  description = "Technical owner of the provisioned assets"
  type        = string
  default     = "Darshan Nair"
}

variable "vnet_address_space" {
  description = "The address space allocated to the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_web_prefix" {
  description = "The CIDR address prefix for the web workload subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}