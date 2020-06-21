output "id"  {
    value = azurerm_storage_container.container.id
}

output "has_immutability_policy"  {
    value = azurerm_storage_container.container.has_immutability_policy
}

output "has_legal_hold"  {
    value = azurerm_storage_container.container.has_legal_hold
}

// output "properties"  {
//     value = azurerm_storage_container.container.properties
// }