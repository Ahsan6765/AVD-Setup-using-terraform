# modules/resource-group/main.tf

resource "azurerm_resource_group" "rg" {
  name     = "ah-avd-rg-${var.environment}"
  location = var.location
  tags     = var.tags
}

output "name" {
  value = azurerm_resource_group.rg.name
}
