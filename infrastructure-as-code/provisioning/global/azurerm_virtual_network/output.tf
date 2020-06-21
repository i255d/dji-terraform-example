
  output "virtual_network_id" {
    value = azurerm_virtual_network.avn.id
  }
  output "virtual_network_name" {
    value = azurerm_virtual_network.avn.name
  }
  output "virtual_network_resource_group_name" {
    value = azurerm_virtual_network.avn.resource_group_name
  }
  output "virtual_network_location" {
    value = azurerm_virtual_network.avn.location
  }
  output "virtual_network_address_space" {
    value = azurerm_virtual_network.avn.address_space
  }
  output "virtual_network_subnet" {
    value = azurerm_virtual_network.avn.subnet
  }
  
