output "resource_group_name" {
  description = "Name of the AVD resource group"
  value       = module.resource_group.name
}

output "vnet_name" {
  description = "Name of the AVD virtual network"
  value       = module.network.vnet_name
}

output "subnet_id" {
  description = "ID of the AVD subnet"
  value       = module.network.subnet_id
}

output "host_pool_name" {
  description = "Name of the AVD Host Pool"
  value       = module.avd.hostpool_name
}

output "workspace_name" {
  description = "Name of the AVD Workspace"
  value       = module.avd.workspace_name
}

output "registration_token" {
  description = "AVD Host Pool registration token (temporary)"
  value       = module.avd.registration_token
  sensitive   = true
}

output "vm_private_ips" {
  description = "Private IP addresses of session host VMs"
  value       = module.session_hosts.private_ips
}
