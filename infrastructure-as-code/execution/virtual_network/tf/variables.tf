variable "virtual_network_resource_group_name" {}
variable "virtual_network_name" {}
variable "virtual_network_address_space" { type = list(string) }
variable "network_security_group_name" {}
variable "virtual_network_dns_servers" { type = list(string) }

variable "cost_center" {}
variable "environment" {}
variable "location" {}

// variable "public_ip" {}
// variable "service_endpoints" { type = list(string) }
// variable "virtual_network_gateway" {}
// variable "sku" {}
// variable "gateway_config" {}
// variable "gateway_subnet" {}
// variable "gw_address_allocation" {}
// variable "gw_subnet_address" {}
// variable "p2s_vpn_client_configuration" {}
// variable "root_certificate_name" {}
// variable "certpath" {}
// variable "gw_type" {}
// variable "gw_vpn_type" {}
// variable "gw_active_active" {}
// variable "gw_enable_bgp" {}
// variable "vpn_client_protocols" { type = list(string) }
// variable "customer_name" {}
