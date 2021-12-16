resource "azurerm_storage_account" "example" {
  name                     = "storagepagerusd80"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "share" {
  name                 = "sharefile"
  storage_account_name = azurerm_storage_account.example.name
  quota                = 50
}

resource "azurerm_storage_share_file" "example" {
  name             = "index.html"
  storage_share_id = azurerm_storage_share.share.id
  source           = "index.html"
}