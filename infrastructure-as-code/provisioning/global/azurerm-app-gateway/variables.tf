variable "name_prefix" {
  description = "naming prefix to use"
  default     = ""
}

variable "resource_group_name" {
  description = "Name of the resource group to place App Gateway in."
}

variable "name" {
  description = "Name of App Gateway"
}

variable "location" {
  description = "Location to place App Gateway in."
}

variable "subnet_id" {
  description = "The id of the subnet to place the app gateway in"
}

variable "frontend_ip_configs" {
  description = "Collection of frontend IP configurations for this application gateway"
  type = list(object({
    name                 = string
    public_ip_address_id = string
    }
  ))
}

variable "frontend_ports" {
  description = "List of frontend ports"
  type = list(object({
    name = string
    port = number
  }))
}

variable "backend_address_pools" {
  description = "List of backend address pools."
  type = list(object({
    name         = string
    ip_addresses = list(string)
    fqdns        = list(string)
  }))
}
variable "backend_http_settings" {
  description = "List of backend HTTP settings."
  type = list(object({
    name                                = string
    has_cookie_based_affinity           = bool
    path                                = string
    port                                = number
    is_https                            = bool
    request_timeout                     = number
    probe_name                          = string
    pick_host_name_from_backend_address = bool
    host_name                           = string
  }))
}
variable "http_listeners" {
  description = "List of HTTP listeners."
  type = list(object({
    name                           = string
    is_https                       = bool
    frontend_port_name             = string
    frontend_ip_configuration_name = string
    ssl_certificate_name           = string
  }))
}
variable "ssl_certificates" {
  description = "List of SSL Certificates to attach to this application gateway."
  type = list(object({
    name     = string
    data     = string
    password = string
  }))
  default = []
}

variable "request_routing_rules" {
  description = "Request routing rules to be used for listeners."
  type = list(object({
    name                       = string
    http_listener_name         = string
    backend_address_pool_name  = string
    backend_http_settings_name = string
    is_path_based              = bool
    #url path map name is optional
    #url_path_map_name          = string
  }))
}
variable "is_public_ip_allocation_static" {
  description = "Is the public IP address of the App Gateway static?"
  default     = false
}
variable "sku_name" {
  description = "Name of App Gateway SKU."
  default     = "Standard_Small"
}
variable "sku_tier" {
  description = "Tier of App Gateway SKU."
  default     = "Standard"
}
variable "sku_capacity" {
  description = "The capacity of the Application Gateway"
  type        = number
  default     = 1
}
variable "probes" {
  description = "Health probes used to test backend health."
  default     = []
  type = list(object({
    name                                      = string
    path                                      = string
    is_https                                  = bool
    pick_host_name_from_backend_http_settings = bool
    host                                      = string
  }))
}

variable "url_path_maps" {
  description = "URL path maps associated to path-based rules."
  default     = []
  type = list(object({
    name                               = string
    default_backend_http_settings_name = string
    default_backend_address_pool_name  = string
    path_rules = list(object({
      name                       = string
      backend_address_pool_name  = string
      backend_http_settings_name = string
      paths                      = list(string)
    }))
  }))
}
