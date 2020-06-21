
resource "azurerm_subnet" "vnsn" {
  name                 = var.subnet_name
  resource_group_name  = var.virtual_network_resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.address_prefixes
  service_endpoints    = var.service_endpoints
}
