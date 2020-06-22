
resource azurerm_key_vault "akvault" {
  name                              = var.key_vault_name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  enabled_for_disk_encryption       = var.enabled_for_disk_encryption
  enabled_for_deployment            = var.enabled_for_deployment
  enabled_for_template_deployment   = var.enabled_for_template_deployment
  tenant_id                         = var.current_tenant_id
  soft_delete_enabled               = var.soft_delete_enabled
  purge_protection_enabled          = var.purge_protection_enabled
  sku_name                          = var.kv_sku_name

  access_policy {
    tenant_id                   = var.current_tenant_id
    object_id                   = var.current_object_id
    certificate_permissions     = var.certificate_permissions 
    key_permissions             = var.key_permissions
    secret_permissions          = var.secret_permissions
    storage_permissions         = var.storage_permissions
  }

  network_acls {
    default_action              = var.network_acls_default_action
    bypass                      = var.network_acls_bypass
    ip_rules                    = var.network_acls_ip_rules
    virtual_network_subnet_ids  = var.network_acls_virtual_network_subnet_ids
  }

  tags = var.common_tags
}
