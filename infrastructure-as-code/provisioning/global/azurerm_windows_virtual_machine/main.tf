
resource "azurerm_windows_virtual_machine" "wvm" {
    name                = var.windows_virtual_machine_name
    resource_group_name = var.resource_group_name
    location            = var.location
    size                = var.size
    admin_username      = var.admin_username
    admin_password      = var.admin_password
    network_interface_ids = [
      var.network_interface_id,
    ]
    #availability_set_id = var.availability_set_id\
    #zone is prefered over set.  Stop working on sets.
    zone = var.zone
  
    os_disk {
      name                 = var.os_disk_name
      caching              = var.os_disk_caching
      storage_account_type = var.os_disk_storage_account_type
      disk_size_gb         = var.os_disk_size_gb
    }
  
    source_image_reference {
      publisher = var.source_image_reference_publisher
      offer     = var.source_image_reference_offer
      sku       = var.source_image_reference_sku
      version   = var.source_image_reference_version
    }

    // delete_os_disk_on_termination = true

    // delete_data_disks_on_termination = true

    timeouts {
      create = "45m"
      update = "45m"
      delete = "2h"
    }

}
