# Create an App Service Plan

Creation of an Azure App Service Plan with an associated app service.

Reference:
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_plan

## Initialize Terraform

````
terraform init
terraform plan
````

## Add the App Service Resource Configuration

Content:

````
resource "azurerm_app_service_plan" "demo" {
  name = join("-", ["plan", var.namespace, var.environment])
  resource_group_name = azurerm_resource_group.demo.name
  location = azurerm_resource_group.demo.demo.location

  sku {
    tier = "Standard"
    size = "S1"
  }

  tags = {
    environment = var.environment
  }
}

````

## Create the resources

Specify the default value for the namespace.

````
terraform apply
````

## Add an App Service to the App Service plan

Content:

````
resource "azurerm_app_service" "demo" {
  name                = join("", [var.namespace, var.environment])
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
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
````

### Apply the changes

````
terraform validate
terraform fmt
terraform apply
````

## Add a slot to the App Service

Content:

````
resource "azurerm_app_service_slot" "demo_dev" {
  name                = "dev"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
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

### Apply the changes

````
terraform validate
terraform fmt
terraform apply

````

## Add a slot to the App Service via the portal and import into Terraform

* Add a qa slot to the app service in the Azure Portal.
* Get the Azure Resource id of the new slot via the portal.
* Add the configuration for the slot

Content:

````

resource "azurerm_app_service_slot" "demo_qa" {
  name                = "qa"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  app_service_name    = azurerm_app_service.demo.name
  app_service_plan_id = azurerm_app_service_plan.demo.id

  identity {
    type = "SystemAssigned"
  }
}
````

* Import the slot

````
terraform state list

terraform import azurerm_app_service_slot.demo_qa <Azure Resource Id>
````

Verify the import

````
terraform plan

````
## Clean Up

````
terraform destroy

````