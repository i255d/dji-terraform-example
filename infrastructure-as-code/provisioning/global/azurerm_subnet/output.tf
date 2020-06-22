
output "id" {
    value = azurerm_subnet.vnsn.id
}

output "subnet_name" {
  value = azurerm_subnet.vnsn.name
}

output "subnet_resource_group_name" {
  value = azurerm_subnet.vnsn.resource_group_name
}

output "subnet_virtual_network_name" {
  value = azurerm_subnet.vnsn.virtual_network_name
}

output "subnet_address_prefix" {
  value = azurerm_subnet.vnsn.address_prefix
}
  