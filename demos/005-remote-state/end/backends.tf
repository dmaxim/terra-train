terraform {
    backend "azurerm" {
      resource_group_name = "rg-dart-devops-dev"
      storage_account_name = "dartdevops"
      container_name = "demotf"
      key = "<yourname>.tfstate"
    }
}