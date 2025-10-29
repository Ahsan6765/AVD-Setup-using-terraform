/* main.tf - root module wiring
   Ensure modules exist under ./modules/<name>
*/

module "resource_group" {
  source      = "./modules/resource-group"
  location    = var.location
  environment = var.environment
  tags        = var.tags
}

module "network" {
  source          = "./modules/network"
  resource_group  = module.resource_group.name
  location        = var.location
  vnet_name       = var.vnet_name
  vnet_cidr       = var.vnet_cidr
  subnet_name     = var.subnet_name
  subnet_cidr     = var.subnet_cidr
  nsg_name        = var.nsg_name
  admin_public_ip = var.admin_public_ip
  tags            = var.tags

  depends_on = [module.resource_group]
}

module "avd" {
  source         = "./modules/avd"
  resource_group = module.resource_group.name
  location       = var.location
  hostpool_name  = var.hostpool_name
  appgroup_name  = var.appgroup_name
  workspace_name = var.workspace_name
  tags           = var.tags
  depends_on     = [module.resource_group]

}

module "session_hosts" {
  source                  = "./modules/vm"
  resource_group          = module.resource_group.name
  location                = var.location
  subnet_id               = module.network.subnet_id
  hostpool_id             = module.avd.hostpool_id
  registration_token      = module.avd.registration_token
  vm_admin_username       = var.vm_admin_username
  vm_admin_password       = var.vm_admin_password
  vm_size                 = var.vm_size
  vm_count                = var.vm_count
  environment             = var.environment
  env                     = var.env
  tags                    = var.tags
  registration_dependency = module.avd
  depends_on = [module.avd]
}
