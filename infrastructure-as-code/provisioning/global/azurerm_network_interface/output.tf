 
output "virtual_machine_id" {
  value = azurerm_network_interface.nic.virtual_machine_id
}
# - If the Virtual Machine using this Network Interface is part of an Availability Set,
# then this list will have the union of all DNS servers from all Network Interfaces that are part of the Availability Set.
output "applied_dns_servers" {
  value = azurerm_network_interface.nic.applied_dns_servers
}

output "nic_id" {
  value = azurerm_network_interface.nic.id
}

output "mac_address" {
  value = azurerm_network_interface.nic.mac_address
}

output "private_ip_address" {
  value = azurerm_network_interface.nic.private_ip_address 
}

output "private_ip_addresses" {
  value = azurerm_network_interface.nic.private_ip_addresses 
}
