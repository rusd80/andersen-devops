resource "azurerm_storage_account" "shareacc" {
  name                     = "storagepagerusd801"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "shares" {
  name                 = "sharefile"
  storage_account_name = azurerm_storage_account.shareacc.name
  quota                = 1
}

resource "azurerm_storage_share_file" "myfile" {
  name             = "index.html"
  storage_share_id = azurerm_storage_share.shares.id
  source           = "index.html"
}

