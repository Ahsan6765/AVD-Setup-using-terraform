# -------------------------------
# General / Environment Variables
# -------------------------------
variable "environment" {
  description = "Deployment environment name (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    environment = "dev"
    project     = "avd"
    owner       = "CloudTeam"
  }
}

# -------------------------------
# Networking Variables
# -------------------------------
variable "vnet_name" {
  description = "Virtual Network name"
  type        = string
  default     = "vnet-avd-dev"
}

variable "vnet_cidr" {
  description = "Address space for VNet"
  type        = string
  default     = "10.10.0.0/16"
}

variable "subnet_name" {
  description = "Subnet name for session hosts"
  type        = string
  default     = "sn-avd-sessionhosts-dev"
}

variable "subnet_cidr" {
  description = "Address prefix for session hosts subnet"
  type        = string
  default     = "10.10.1.0/24"
}

variable "nsg_name" {
  description = "Network Security Group name"
  type        = string
  default     = "nsg-avd-dev"
}

variable "admin_public_ip" {
  description = "Admin public IP/CIDR allowed for RDP"
  type        = string
}

# -------------------------------
# AVD Variables
# -------------------------------
variable "hostpool_name" {
  description = "AVD Host Pool name"
  type        = string
  default     = "avd-hostpool-dev"
}

variable "appgroup_name" {
  description = "AVD Application Group name"
  type        = string
  default     = "avd-appgroup-dev"
}

variable "workspace_name" {
  description = "AVD Workspace name"
  type        = string
  default     = "avd-workspace-dev"
}

# -------------------------------
# VM Variables
# -------------------------------

variable "env" {
  description = "Deployment environment name"
  type        = string
  default     = "dev"
}

variable "vm_admin_username" {
  description = "Admin username for AVD session host VMs"
  type        = string
  default     = "avdadmin"
}

variable "vm_admin_password" {
  description = "Admin password for AVD session host VMs"
  type        = string
  sensitive   = true
}

variable "vm_size" {
  description = "Size of the AVD session host VMs"
  type        = string
  default     = "Standard_B2ms"
}

variable "vm_count" {
  description = "Number of AVD session host VMs to deploy"
  type        = number
  default     = 1
}

# variable "registration_token" {
#   type        = string
#   sensitive   = true
#   description = "AVD Host Pool registration token"
# }