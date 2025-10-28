
// =============================================================================
// ===================== Public IP for VM ======================================
// =============================================================================

resource "azurerm_public_ip" "vm_public_ip" {
  count               = var.vm_count
  name                = "pip-avd-sh-${count.index + 1}-${var.env}"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
}
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
    public_ip_address_id          = azurerm_public_ip.vm_public_ip[count.index].id

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
# resource "azurerm_virtual_machine_extension" "avd_registration" {
#   count                = var.vm_count
#   name                 = "AVDRegistration"
#   virtual_machine_id   = element(azurerm_windows_virtual_machine.vm[*].id, count.index)
#   publisher            = "Microsoft.Powershell"
#   type                 = "DSC"
#   type_handler_version = "2.73"

#   settings = <<SETTINGS
# {
#   "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_11_2023.zip",
#   "configurationFunction": "Configuration.ps1\\AddSessionHost",
#   "properties": {
#       "registrationInfoToken": "${var.registration_token}"
#   }
# }
# SETTINGS
# }


# =======================================================================================================================================


# Replace existing azurerm_virtual_machine_extension.avd_registration with this block
resource "azurerm_virtual_machine_extension" "avd_registration" {
  count                = var.vm_count
  name                 = "AVDRegistration"
  virtual_machine_id   = element(azurerm_windows_virtual_machine.vm[*].id, count.index)
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    commandToExecute = <<-POWERSHELL
      powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "
      $ErrorActionPreference='Stop';
       $outdir='C:\\Windows\\Temp\\AVDInstall';
       if (-not (Test-Path $outdir)) { New-Item -Path $outdir -ItemType Directory | Out-Null };
       $agentFile = Join-Path $outdir 'agent.msi';
       $bootFile  = Join-Path $outdir 'bootloader.msi';
       $fwlinks = @('https://go.microsoft.com/fwlink/?linkid=2310011','https://go.microsoft.com/fwlink/?linkid=2311028');
       try {
         Invoke-WebRequest -Uri $fwlinks[0] -OutFile $agentFile -UseBasicParsing -ErrorAction Stop;
         Invoke-WebRequest -Uri $fwlinks[1] -OutFile $bootFile  -UseBasicParsing -ErrorAction Stop;
       } catch {
         Write-Output 'ERROR: Failed to download installers:'; Write-Output $_.ToString(); exit 2;
       };
       Write-Output 'Downloaded files:'; Write-Output $agentFile; Write-Output $bootFile;
  # Install agent with registration token (injected from Terraform var)
  $regToken = "${var.registration_token}";
  $arg1 = "/i `"$agentFile`" /quiet REGISTRATIONTOKEN=`"$regToken`"";
       $ret = Start-Process -FilePath 'msiexec.exe' -ArgumentList $arg1 -Wait -PassThru;
       if ($ret.ExitCode -ne 0) { Write-Output ('ERROR: agent installer exit code ' + $ret.ExitCode); exit 4 }
       # Install bootloader
       $arg2 = "/i `"$bootFile`" /quiet";
       $ret2 = Start-Process -FilePath 'msiexec.exe' -ArgumentList $arg2 -Wait -PassThru;
       if ($ret2.ExitCode -ne 0) { Write-Output ('ERROR: bootloader exit code ' + $ret2.ExitCode); exit 5 }
       # Log success
       New-Item -Path 'C:\\ProgramData\\AVDRegistration' -ItemType Directory -Force | Out-Null;
       'Installed: ' + (Get-Item $agentFile).FullName + ' , ' + (Get-Item $bootFile).FullName | Out-File -FilePath 'C:\\ProgramData\\AVDRegistration\\install.log' -Encoding utf8 -Append;
       exit 0"
    POWERSHELL
  })

  protected_settings = jsonencode({
    environment = {
      AVD_REGISTRATION_TOKEN = var.registration_token
    }
  })

  depends_on = [azurerm_windows_virtual_machine.vm]
}




# --------------------------
# Outputs
# --------------------------
output "private_ips" {
  value = [for n in azurerm_network_interface.nic : n.private_ip_address]
}
