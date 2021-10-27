#--- main.tf ---#

# Create an Azure Resource Group

resource "azurerm_resource_group" "demo" {
  name     = join("-", ["rg", var.namespace, var.environment])
  location = var.location

  tags = {
    environment = var.environment
  }
}

# Create the App Service Plan

module "app_service" {
  source              = "./modules/app-service"
  location            = azurerm_resource_group.demo.location
  namespace           = var.namespace
  resource_group_name = azurerm_resource_group.demo.name
  environment         = var.environment
}