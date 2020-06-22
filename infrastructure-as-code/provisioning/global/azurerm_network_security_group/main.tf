
resource "azurerm_network_security_group" "nsg" {
  name                          = var.network_security_group_name
  location                      = var.location
  resource_group_name           = var.resource_group_name

  security_rule {
    name                       = "WinRM"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985"
    source_address_prefixes    = ["10.160.0.0/16"]
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "SSH"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = ["50.28.39.117"]
    destination_address_prefix = "10.160.1.0/24"
  }

  security_rule {
    name                       = "rdp"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefixes    = ["10.160.0.0/16"]
    destination_address_prefix = "10.160.0.0/16"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 2001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefixes    = ["10.160.0.0/16"]
    destination_address_prefix = "10.160.1.0/24"
  }
  
  security_rule {
    name                       = "Analysis_web"
    priority                   = 2003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "2382-2383"
    source_address_prefixes    = ["10.160.0.0/16"]
    destination_address_prefix = "10.160.1.0/24"
  }

  security_rule {
    name                       = "Analysis_data"
    priority                   = 2025
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "2382-2383"
    source_address_prefixes    = ["10.160.0.0/16"]
    destination_address_prefix = "10.160.3.0/24"
  }

  security_rule {
    name                       = "SQL_web"
    priority                   = 2002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefixes    = ["10.160.0.0/16"]
    destination_address_prefix = "10.160.1.0/24"
  }

  security_rule {
    name                       = "SQL_data"
    priority                   = 2026
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefixes    = ["10.160.0.0/16"]
    destination_address_prefix = "10.160.3.0/24"
  }

  tags = var.common_tags

}

