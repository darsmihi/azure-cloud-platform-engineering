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