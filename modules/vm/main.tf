# modules/vm/main.tf

# resource "azurerm_public_ip" "vm_public_ip" {
#   count               = var.vm_count
#   name                = "pip-avd-sh-${count.index + 1}-${var.env}"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }
// =============================================================================
// =============================================================================
// =============================================================================
// =============================================================================
locals {
  vm_prefix = "vm-avd-sh"
}

resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "${local.vm_prefix}-${count.index + 1}-${var.environment}-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "vm" {
  count                 = var.vm_count
  name                  = "${local.vm_prefix}-${count.index + 1}-${var.environment}"
  resource_group_name   = var.resource_group
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.vm_admin_username
  admin_password        = var.vm_admin_password
  network_interface_ids = [element(azurerm_network_interface.nic[*].id, count.index)]
  provision_vm_agent    = true

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-23h2-avd"
    version   = "latest"
  }

  tags = var.tags
}

# --------------------------
# AVD Registration Extension
# --------------------------
resource "azurerm_virtual_machine_extension" "avd_registration" {
  count                = var.vm_count
  name                 = "AVDRegistration"
  virtual_machine_id   = element(azurerm_windows_virtual_machine.vm[*].id, count.index)
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.73"

  settings = <<SETTINGS
{
  "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_11_2023.zip",
  "configurationFunction": "Configuration.ps1\\AddSessionHost",
  "properties": {
      "registrationInfoToken": "${var.registration_token}"
  }
}
SETTINGS
}

# --------------------------
# Outputs
# --------------------------
output "private_ips" {
  value = [for n in azurerm_network_interface.nic : n.private_ip_address]
}
