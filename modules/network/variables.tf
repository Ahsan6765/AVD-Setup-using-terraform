variable "resource_group" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "vnet_name" {
  description = "VNet name"
  type        = string
}

variable "vnet_cidr" {
  description = "VNet address space"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
}

variable "subnet_cidr" {
  description = "Subnet address prefix"
  type        = string
}

variable "nsg_name" {
  description = "NSG name"
  type        = string
}

variable "admin_public_ip" {
  description = "Allowed public IP for RDP"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
}
