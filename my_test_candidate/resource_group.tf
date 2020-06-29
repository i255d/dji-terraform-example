
terraform {
  required_version = ">= 0.12.26"
}

provider "azurerm" {
  version = ">=2.15.0"
  features {}
}

variable resource_group_name {
    description     = "First part of name of the resource group."
    default         = "my-test-candidate"
}
variable location {
    description     = "A list of Azure US locations."
    default         = ["eastus", "eastus2", "westus", "northcentralus", "southcentralus", "westcentralus", "westus2", "centralus"]
}

variable environment {
    description     = "Examples of environment might be prod, uat, qa, dev."
    default         = "prod"
}

variable cost_center {
    description     = "Cost centers may be required for cost aloacations."
    default         = "dji_personal"
}

locals {
    common_tags = {     
        environment     = var.environment
        cost_center     = var.cost_center
        Department      = "DevOps"
    }
}

resource "azurerm_resource_group" "arg" {
    count               = length(var.location)
    name                = "${var.resource_group_name}-${var.location[count.index]}"
    location            = var.location[count.index]
    tags                = local.common_tags
}

output "id" {
    value               = azurerm_resource_group.arg.*.id
}
output "name" {
    value               = azurerm_resource_group.arg.*.name
}
output "location" {
    value               = azurerm_resource_group.arg.*.location
}
