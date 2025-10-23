# modules/avd/main.tf

# --------------------------
# Host Pool
# --------------------------
resource "azurerm_virtual_desktop_host_pool" "hostpool" {
  name                = var.hostpool_name
  location            = var.location
  resource_group_name = var.resource_group
  type                = "Pooled"
  preferred_app_group_type = "Desktop"
  maximum_sessions_allowed = 3
  load_balancer_type       = "DepthFirst"
  friendly_name            = "AVD Host Pool Dev"
  start_vm_on_connect      = true
  tags                     = var.tags
}

# --------------------------
# Application Group
# --------------------------
resource "azurerm_virtual_desktop_application_group" "appgroup" {
  name                = var.appgroup_name
  location            = var.location
  resource_group_name = var.resource_group
  host_pool_id        = azurerm_virtual_desktop_host_pool.hostpool.id
  type                = "Desktop"
  friendly_name       = "AVD Desktop App Group Dev"
  tags                = var.tags
}

# --------------------------
# Workspace
# --------------------------
resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group
  friendly_name       = "AVD Workspace Dev"
  tags                = var.tags
}

# --------------------------
# Workspace & App Group Association
# --------------------------
resource "azurerm_virtual_desktop_workspace_application_group_association" "assoc" {
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
  application_group_id = azurerm_virtual_desktop_application_group.appgroup.id
}

# --------------------------
# Registration Info
# --------------------------
resource "azurerm_virtual_desktop_host_pool_registration_info" "reg" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.hostpool.id
  expiration_date = timeadd(timestamp(), "48h")
}

# --------------------------
# Outputs
# --------------------------
output "hostpool_name" {
  value = azurerm_virtual_desktop_host_pool.hostpool.name
}

output "workspace_name" {
  value = azurerm_virtual_desktop_workspace.workspace.name
}

output "hostpool_id" {
  value = azurerm_virtual_desktop_host_pool.hostpool.id
}

output "registration_token" {
  value     = azurerm_virtual_desktop_host_pool_registration_info.reg.token
  sensitive = true
}
