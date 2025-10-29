# 🌩️ Azure Virtual Desktop (AVD) - Dev Environment using Terraform

This project provisions a complete **Azure Virtual Desktop (AVD) environment** in a **Dev environment** using **Terraform**.  
It includes the creation of all core AVD resources such as **Host Pool**, **Application Group**, **Workspace**, and **Session Hosts**, along with a supporting **virtual network**, **subnet**, and **network security group (NSG)**.

---

## 🏗️ **Architecture Overview**

The Terraform configuration automates deployment of the following key components:

| Component | Description |
|------------|-------------|
| **Resource Group** | Dedicated RG for AVD Dev environment resources |
| **Virtual Network & Subnet** | Network infrastructure for session hosts |
| **Network Security Group (NSG)** | Secures inbound/outbound traffic for the subnet |
| **Host Pool** | Logical container for AVD session hosts |
| **Application Group** | Associates applications with host pool |
| **Workspace** | User-facing entry point for published desktops and apps |
| **Session Hosts (VMs)** | Virtual machines joined to the host pool |

---

## 📂 **Directory Structure**


Recreate a fresh registration token (since it expires quickly):

az desktopvirtualization hostpool registration-info reset `
  --name avd-hostpool-dev `
  --resource-group ah-avd-rg-dev `
  --expiration-time "2025-10-29T23:59:00Z"


OR run this given below

az desktopvirtualization hostpool registration-info reset --name avd-hostpool-dev --resource-group ah-avd-rg-dev --expiration-time "2025-10-29T23:59:00Z"


View the New Token

Once reset, you can get the new token by running:

az desktopvirtualization hostpool registration-info show `
  --name avd-hostpool-dev `
  --resource-group ah-avd-rg-dev `
  --query token -o tsv