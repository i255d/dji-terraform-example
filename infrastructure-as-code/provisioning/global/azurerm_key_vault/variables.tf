
variable key_vault_name {}
variable resource_group_name {}
variable enabled_for_disk_encryption {}
variable current_tenant_id {}
variable current_object_id {}
variable soft_delete_enabled {}
variable purge_protection_enabled {}
variable enabled_for_deployment {}
variable enabled_for_template_deployment {}
variable kv_sku_name {}
variable key_permissions { type = list(string) }
variable secret_permissions { type = list(string) }
variable storage_permissions { type = list(string) }
variable certificate_permissions { type = list(string) }
variable network_acls_default_action {}
variable network_acls_bypass {}
variable network_acls_ip_rules { type = list(string) }
variable network_acls_virtual_network_subnet_ids { type = list(string) }
variable common_tags {}
variable location {}
