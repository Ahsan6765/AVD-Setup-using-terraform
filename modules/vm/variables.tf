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
  type      = string
  sensitive = true
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
