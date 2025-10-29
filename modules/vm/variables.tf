variable "resource_group" {
  type = string
}
variable "location" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "hostpool_id" {
  type = string
}
variable "registration_token" {
  type        = string
  sensitive   = true
  description = "AVD Host Pool registration token"
}

variable "registration_dependency" {
  description = "Explicit dependency on AVD host pool registration to ensure proper ordering"
}

variable "env" {
  description = "Environment name (e.g., dev, test, prod)"
  type        = string
}

variable "vm_admin_username" {
  type = string
}
variable "vm_admin_password" {
  type      = string
  sensitive = true
}
variable "vm_size" {
  type = string
}
variable "vm_count" {
  type = number
}
variable "environment" {
  type = string
}
variable "tags" {
  type = map(string)
}


