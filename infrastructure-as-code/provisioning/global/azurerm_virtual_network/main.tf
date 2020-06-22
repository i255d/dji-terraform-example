
resource "azurerm_virtual_network" "avn" {
    name                = var.virtual_network_name
    location            = var.location
    resource_group_name = var.virtual_network_resource_group_name
    address_space       = var.virtual_network_address_space
    #dns_servers         = var.virtual_network_dns_servers
    tags                = var.common_tags
  }
