terraform {
    backend "azurerm" {
      resource_group_name = "<storage account resource group>"
      storage_account_name = "<storage account name>"
      container_name = "demotf"
      key = "<yourname>.tfstate"
    }
}