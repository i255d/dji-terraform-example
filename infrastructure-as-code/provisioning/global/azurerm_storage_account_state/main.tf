
resource "azurerm_storage_account" "sa" {
  name                                =  var.storage_account_name
  resource_group_name                 =  var.resource_group_name
  location                            =  var.location
  account_tier                        =  var.account_tier
  access_tier                         =  var.access_tier
  account_replication_type            =  var.account_replication_type
  account_kind                        =  var.account_kind
  enable_https_traffic_only           =  var.enable_https_traffic_only
  # network_rules {
  #   default_action                    = var.network_rules_default_action
  #   bypass                            = var.network_rules_bypass
  #   virtual_network_subnet_ids        = var.virtual_network_subnet_ids
  #   ip_rules                          = var.ip_rules
  # }
  tags                                =  var.common_tags
}

// https://azure.microsoft.com/en-us/pricing/details/storage/
// https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview
  #account_encryption_source           =  var.account_encryption_source
  #enable_advanced_threat_protection   =  var.enable_advanced_threat_protection 
    #enable_file_encryption              =  var.enable_file_encryption