# modules/network/main.tf

# --------------------------
# Virtual Network
# --------------------------
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = var.resource_group
  tags                = var.tags
}

# --------------------------
# Subnet
# --------------------------
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_cidr]
}

# --------------------------
# Network Security Group
# --------------------------
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group
  tags                = var.tags
}

# Allow RDP from admin’s public IP
resource "azurerm_network_security_rule" "rdp_rule" {
  name                        = "Allow-RDP-Admin"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix        = var.admin_public_ip
  destination_address_prefix   = "*"
  resource_group_name         = var.resource_group
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Allow AVD Infra Communication
resource "azurerm_network_security_rule" "avd_infra_rule" {
  name                        = "Allow-AVD-Infrastructure"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["443"]
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = var.resource_group
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# --------------------------
# Associate NSG with Subnet
# --------------------------
resource "azurerm_subnet_network_security_group_association" "assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# --------------------------
# Outputs
# --------------------------
output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "subnet_id" {
  value = azurerm_subnet.subnet.id
}
