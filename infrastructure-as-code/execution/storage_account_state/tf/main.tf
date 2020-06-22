
locals {
    common_tags = {     
        allocation              = var.cost_center
        environment             = var.environment
        location                = var.location
    }
}

module "azurerm_resource_group" {
    source = "../../../provisioning/global/azurerm_resource_group"
    resource_group_name         = var.tbe_resource_group_name
    location                    = var.location
    common_tags                 = local.common_tags
}

module "azurerm_storage_account" {
    source = "../../../provisioning/global/azurerm_storage_account"
    storage_account_name        =  var.storage_account_state_name
    resource_group_name         =  module.azurerm_resource_group.name
    location                    =  var.location
    account_tier                =  var.account_tier
    access_tier                 =  var.access_tier
    account_replication_type    =  var.account_replication_type
    account_kind                =  var.account_kind
    #enable_file_encryption     =  var.enable_file_encryption  
    enable_https_traffic_only   =  var.enable_https_traffic_only
    common_tags                 =  local.common_tags
}

module "azurerm_storage_container" {
    source  =  "../../../provisioning/global/azurerm_storage_container"
    container_name              =  var.tbe_container_name
    storage_account_name        =  module.azurerm_storage_account.name
    container_access_type       =  var.container_access_type
}
