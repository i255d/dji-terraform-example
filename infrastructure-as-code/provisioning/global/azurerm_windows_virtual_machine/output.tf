    output "id" {
        value = azurerm_windows_virtual_machine.wvm.id
    }

    output "identity" {
        value = azurerm_windows_virtual_machine.wvm.identity
    }

    output "private_ip_address" {
        value = azurerm_windows_virtual_machine.wvm.private_ip_address
    }

    output "public_ip_address" {
        value = azurerm_windows_virtual_machine.wvm.public_ip_address
    }

    output "virtual_machine_id" {
        value = azurerm_windows_virtual_machine.wvm.virtual_machine_id
    }

    #An identity block exports the following:
    // output "windows_virtual_machine_principal_id" {
    //     value = azurerm_windows_virtual_machine.wvm.principal_id
    // }
