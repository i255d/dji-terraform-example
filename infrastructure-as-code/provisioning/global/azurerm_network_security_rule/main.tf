
resource "azure_security_group_rule" "asgr" {
  name                       = var.security_group_rule_name
  security_group_names       = ["${var.security_group_names}"]
  type                       = var.security_group_rule_type
  action                     = var.security_group_rule_action
  priority                   = var.security_group_rule_priority
  source_address_prefix      = var.source_address_prefix
  source_port_range          = var.source_port_range
  destination_address_prefix = var.destination_address_prefix
  destination_port_range     = var.destination_port_range
  protocol                   = var.protocol
}
