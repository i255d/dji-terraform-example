
resource "azurerm_virtual_network_gateway" "vngw" {
  name                = var.virtual_network_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = var.virtual_network_gateway_type
  vpn_type = var.virtual_network_gateway_vpn_type

  active_active = var.active_active
  enable_bgp    = var.enable_bgp
  sku           = var.virtual_network_gateway_sku

  ip_configuration {
    name                          = var.ip_configuration_name
    public_ip_address_id          = var.public_ip_address_id
    private_ip_address_allocation = var.private_ip_address_allocation
    subnet_id                     = var.subnet_id
  }

  vpn_client_configuration {
    address_space = var.vpn_client_configuration_address_space

    root_certificate {
      name = var.root_certificate_name

      public_cert_data = var.public_cert_data
    }

    // revoked_certificate {
    //   name       = var.revoked_certificate_name
    //   revoked_certificate = revoked_certificate_thumbprint
    // } 
  }

    tags = var.common_tags
}