
resource azurerm_storage_share "share" {
  name                  = var.share_name
  storage_account_name  = var.storage_account_name
  quota                 = var.share_quota
}
