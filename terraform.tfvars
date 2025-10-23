# Environment
environment = "dev"
location    = "eastus"

# Networking
vnet_cidr    = "10.10.0.0/16"
subnet_cidr  = "10.10.1.0/24"
admin_public_ip = "YOUR.PUBLIC.IP/32" # replace with your actual admin IP

# VM Configuration
vm_admin_username = "avdadmin"
vm_admin_password = "P@ssw0rd123!"
vm_count          = 2
vm_size           = "Standard_D2s_v5"
