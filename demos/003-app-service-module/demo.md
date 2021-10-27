# Using Modules to Streamline Terraform Configuration

## Add The App Service Plan Configuration to the app-service/main.tf file

Content:

````
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

````

Add the variables to the app-service/variables.tf file

Content

````
variable "namespace" {}
variable "environment" {}
variable "resource_group_name" {}
variable "location" {}

````

## Add the module to the main.tf file

Content:

````
module "app_service" {
  source              = "./modules/app-service"
  location            = azurerm_resource_group.demo.location
  namespace           = var.namespace
  resource_group_name = azurerm_resource_group.demo.name
  environment         = var.environment
}
````


### Verify the configuration

````
terraform init
terraform validate
terraform fmt -recursive
terraform plan

````

## Add the configuration for the App Service and Dev Slot to the app-service/main.tf file

Content:

````
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

````

## Apply the configuration

````

terraform validate
terraform fmt -recursive
terraform apply

````

## Clean Up

````
terraform destroy

````