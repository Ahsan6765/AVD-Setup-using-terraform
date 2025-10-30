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





  .\Register-AVDSessionHost.ps1 `
  -ResourceGroup "ah-avd-rg-dev" `
  -VMName "vm-avd-sh-1-dev" `
  -HostPoolToken "eyJhbGciOiJSUzI1NiIsImtpZCI6Ijk0RDQxQUY3MjUyMDFDQzg2MDcwRDQwODI1MkQzMzk2OUEyOEQ0RTciLCJ0eXAiOiJKV1QifQ.eyJSZWdpc3RyYXRpb25JZCI6ImYxZjg1NWE4LTM3NGItNDJkOC1hMTgzLTMwMGNiMjBmNzI0ZCIsIkJyb2tlclVyaSI6Imh0dHBzOi8vcmRicm9rZXItZy11cy1yMS53dmQubWljcm9zb2Z0LmNvbS8iLCJEaWFnbm9zdGljc1VyaSI6Imh0dHBzOi8vcmRkaWFnbm9zdGljcy1nLXVzLXIxLnd2ZC5taWNyb3NvZnQuY29tLyIsIkVuZHBvaW50UG9vbElkIjoiNTg1MjI1ZWMtZjcxZC00NTVhLTk4MTItYjE4ZTM1ODBiOTlhIiwiR2xvYmFsQnJva2VyVXJpIjoiaHR0cHM6Ly9yZGJyb2tlci53dmQubWljcm9zb2Z0LmNvbS8iLCJHZW9ncmFwaHkiOiJVUyIsIkdsb2JhbEJyb2tlclJlc291cmNlSWRVcmkiOiJodHRwczovLzU4NTIyNWVjLWY3MWQtNDU1YS05ODEyLWIxOGUzNTgwYjk5YS5yZGJyb2tlci53dmQubWljcm9zb2Z0LmNvbS8iLCJCcm9rZXJSZXNvdXJjZUlkVXJpIjoiaHR0cHM6Ly81ODUyMjVlYy1mNzFkLTQ1NWEtOTgxMi1iMThlMzU4MGI5OWEucmRicm9rZXItZy11cy1yMS53dmQubWljcm9zb2Z0LmNvbS8iLCJEaWFnbm9zdGljc1Jlc291cmNlSWRVcmkiOiJodHRwczovLzU4NTIyNWVjLWY3MWQtNDU1YS05ODEyLWIxOGUzNTgwYjk5YS5yZGRpYWdub3N0aWNzLWctdXMtcjEud3ZkLm1pY3Jvc29mdC5jb20vIiwiQUFEVGVuYW50SWQiOiI5OWIwNWE3Ny0zMjc5LTQ0MjYtOWEyNy02MzRlYWQ3MGZlMGIiLCJuYmYiOjE3NjE3MjA0NTIsImV4cCI6MTc2MTg5MzI0NywiaXNzIjoiUkRJbmZyYVRva2VuTWFuYWdlciIsImF1ZCI6IlJEbWkifQ.qBJFCDV9Gs9XHowHvL2VYRO4uEmX4Oka74yf4NUg8ruQ2y-pbC7cSx-Ua87E2exzxTAOh7ENQ14JjUZkxzA7HIpQpMscnY1bBdRxK7UOtnAZeUzC1On_gFG5I50JqYj73DBW3i168cIUvY8QGZAIdR8ZLEHg0EI_0qIRl8IQqUI_05lLRSV2wz_VYbVtNZKmJW9w-54T3l_QQIpr3uG-SJPK2Q06qYJ26VJCjuqhFOt21opiGpaM6xhJq_c8cFxZGZyrPgPz1h_n6hzGenC6o57_tvB5Y7d7bkjhEfAF8SY0Xr3YVtpCrlf-vodmGfEQa41KuZlsEBg8eH7fyT1PEw"
