
resource "azurerm_storage_share_directory" "sh_dir" {
  name                  = var.share_directory_name
  share_name            = var.share_name
  storage_account_name  = var.storage_account_name
}
