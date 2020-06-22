
resource "azurerm_resource_group" "arg" {
  name      = var.resource_group_name
  location  = var.location
  tags      = var.common_tags
}
