#--- app-service/main.tf ---#

# Create the App Service plan
resource "azurerm_app_service_plan" "demo" {
  name                = join("-", ["plan", var.namespace, var.environment])
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    tier = "Standard"
    size = "S1"
  }

  tags = {
    environment = var.environment
  }
}

# Create an App Service
resource "azurerm_app_service" "demo" {
  name                = join("", [var.namespace, var.environment])
  resource_group_name = var.resource_group_name
  location            = var.location
  app_service_plan_id = azurerm_app_service_plan.demo.id

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "WEBSITE_HEALTHCHECK_MAXPINGFAILURES" = "10",
    "WEBSITE_NODE_DEFAULT_VERSION"        = "6.9.1",
    "WEBSITE_RUN_FROM_PACKAGE"            = "1",
  }


  site_config {
    health_check_path = "/home"
    default_documents = [
      "Default.htm",
      "Default.html",
      "index.htm",
      "index.html",
      "iisstart.htm"
    ]
    php_version               = "5.6"
    use_32_bit_worker_process = false
  }
}

# Add a slot

resource "azurerm_app_service_slot" "demo_dev" {
  name                = "dev"
  resource_group_name = var.resource_group_name
  location            = var.location
  app_service_name    = azurerm_app_service.demo.name
  app_service_plan_id = azurerm_app_service_plan.demo.id

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "SettingName" = "SettingValue"
  }

  site_config {
    always_on                 = true
    use_32_bit_worker_process = false
  }

  connection_string {
    name  = "ConnectionStringOne"
    value = "ConnectionStringOneValue"
    type  = "Custom"
  }

  connection_string {
    name  = "ConnectionStringTwo"
    value = "ConnectionStringTwoValue"
    type  = "Custom"
  }
}
