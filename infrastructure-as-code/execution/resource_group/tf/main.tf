terraform {
  backend "azurerm" {}
}

locals {
    common_tags = {     
        environment  = var.environment
        cost_center = var.cost_center
        location     = var.location
    }
}

module "azurerm_resource_group" {
    source = "../../../provisioning/global/azurerm_resource_group"
    resource_group_name= var.resource_group_name
    location = var.location
    common_tags = local.common_tags
}