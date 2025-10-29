// ============================================================================
// Module: Virtual Machines for AVD Session Hosts
// ============================================================================

// -----------------------------------------------------------------------------
// Public IP for Each VM
// -----------------------------------------------------------------------------
resource "azurerm_public_ip" "vm_public_ip" {
  count               = var.vm_count
  name                = "pip-avd-sh-${count.index + 1}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
}

// -----------------------------------------------------------------------------
// Local Naming Convention
// -----------------------------------------------------------------------------
locals {
  vm_prefix = "vm-avd-sh"
}

// -----------------------------------------------------------------------------
// Network Interface
// -----------------------------------------------------------------------------
resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "${local.vm_prefix}-${count.index + 1}-${var.environment}-nic"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip[count.index].id
  }

  tags = var.tags
}

// -----------------------------------------------------------------------------
// Windows Virtual Machine
// -----------------------------------------------------------------------------
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

// -----------------------------------------------------------------------------
// AVD registration via Custom Script Extension
// -----------------------------------------------------------------------------
resource "azurerm_virtual_machine_extension" "avd_registration" {
  count                = var.vm_count
  name                 = "AVDRegistration"
  virtual_machine_id   = element(azurerm_windows_virtual_machine.vm[*].id, count.index)
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    fileUris = []
    commandToExecute = <<-POWERSHELL
      powershell -NoProfile -ExecutionPolicy Bypass -Command "
        $ErrorActionPreference = 'Stop'
        $token = '${var.registration_token}'
        $agentUrl = 'https://go.microsoft.com/fwlink/?linkid=2310011'
        $bootUrl  = 'https://go.microsoft.com/fwlink/?linkid=2311028'
        $outdir = 'C:\\Windows\\Temp\\AVDInstall'
        if (-not (Test-Path $outdir)) { New-Item -Path $outdir -ItemType Directory | Out-Null }

        Write-Output 'Downloading agent and bootloader...'
        Invoke-WebRequest -Uri $agentUrl -OutFile "$outdir\\agent.msi" -UseBasicParsing
        Invoke-WebRequest -Uri $bootUrl -OutFile "$outdir\\bootloader.msi" -UseBasicParsing

        Write-Output 'Installing AVD agent...'
        Start-Process msiexec.exe -ArgumentList '/i', "$outdir\\agent.msi", '/quiet', "REGISTRATIONTOKEN=$token" -Wait

        Write-Output 'Installing AVD bootloader...'
        Start-Process msiexec.exe -ArgumentList '/i', "$outdir\\bootloader.msi", '/quiet' -Wait

        Write-Output 'Installation complete. Checking service...'
        Start-Sleep -Seconds 15
        Get-Service -Name RDAgent, RDInfraAgent, RdClientBootLoader | Select Name, Status
      "
    POWERSHELL
  })

  depends_on = [azurerm_windows_virtual_machine.vm]
}


// -----------------------------------------------------------------------------
// Outputs
// -----------------------------------------------------------------------------
output "private_ips" {
  value = [for n in azurerm_network_interface.nic : n.private_ip_address]
}

output "public_ips" {
  value = [for p in azurerm_public_ip.vm_public_ip : p.ip_address]
}
