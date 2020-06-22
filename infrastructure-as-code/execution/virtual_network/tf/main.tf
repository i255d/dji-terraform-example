
terraform {
  backend "azurerm" {}
}

locals {
    resource_group_name = var.virtual_network_resource_group_name
    common_tags = {     
        environment  = var.environment
        cost_center = var.cost_center
        location     = var.location
    }
}

module "azurerm_resource_group" {
    source = "../../../provisioning/global/azurerm_resource_group"
    resource_group_name   = local.resource_group_name
    location              = var.location
    common_tags           = local.common_tags
}

module "azurerm_virtual_network" {
  source                                = "../../../provisioning/global/azurerm_virtual_network"
  virtual_network_name                  = var.virtual_network_name
  location                              = var.location
  virtual_network_resource_group_name   = module.azurerm_resource_group.name
  virtual_network_address_space         = var.virtual_network_address_space
  virtual_network_dns_servers           = var.virtual_network_dns_servers
  common_tags                           = local.common_tags
}

module "azurerm_network_security_group" {
  source                      = "../../../provisioning/global/azurerm_network_security_group"
  resource_group_name         = module.azurerm_resource_group.name
  location                    = var.location
  network_security_group_name = var.network_security_group_name
  common_tags                 = local.common_tags
}
