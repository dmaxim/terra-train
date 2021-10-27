# Using Locals And For Each to Streamline Terraform Configuration

## Create the locals file to use for input

Content:

````
locals {
    app_services = {
        webjobs = {
            name = join("", ["webjobs", var.namespace, var.environment])
        }
    }
}
````


## Update the main.tf file to Pass in the app_service_plans to the App Service Module

Updated Content:

````
module "app_service" {
  source              = "./modules/app-service"
  location            = azurerm_resource_group.demo.location
  namespace           = var.namespace
  resource_group_name = azurerm_resource_group.demo.name
  environment         = var.environment
  app_services        = local.app_services # Adding the app services
}

````

## Add the app_service_plans variable to the app-service module variables.tf

````
variable "app_services" {}
````

## Use the app_service_plans in the app-service module

Updated Content:

````
resource "azurerm_app_service" "demo" {
  for_each            = var.app_services   # Updated to iterate over the app services
  name                = each.value.name
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

````

### Apply the configuration

````
terraform init
terraform fmt -recursive
terraform validate
terraform apply

````


## Add a Second App Service

Update the Locals file:

````
locals {
  app_services = {
    webjobs = {
      name = join("", ["webjobs", var.namespace, var.environment])
    }
    apis = {
        name = join("", ["api", var.namespace, var.environment])
    }
  }
}
````

### Apply the changes

````
terraform validate
terraform apply
````

## Add slots to each app service

Update the locals file:

````
locals {
  app_services = {
    webjobs = {
      name = join("", ["webjobs", var.namespace, var.environment])
      slots = {
        dev = {
          name     = "dev"
          identity = "SystemAssigned"
        }
        qa = {
          name     = "qa"
          identity = "SystemAssigned"
        }
      }
    }
    apis = {
      name = join("", ["api", var.namespace, var.environment])
      slots = {
        dev = {
          name     = "dev"
          identity = "SystemAssigned"
        }
      }
    }
  }
}
````


Add the slot configuration to the app-service/main.tf file

Content:

````
locals {
  app_service_slots = flatten([
    for app_service_key, app_service in var.app_services : [
      for slot_key, slot in app_service.slots : {
        app_service_key  = app_service_key
        slot_key         = slot_key
        app_service_name = azurerm_app_service.demo[app_service_key]
        slot_name        = slot.name
        slot_identity    = slot.identity
      }
    ]
  ])
}
# Add a the slots

resource "azurerm_app_service_slot" "demo_slot" {
  for_each            = {
    for slot in local.app_service_slots : "${slot.app_service_key}.${slot.slot_key}" => slot
  }
  name                = each.value.slot_name
  resource_group_name = var.resource_group_name
  location            = var.location
  app_service_name    = azurerm_app_service.demo[each.value.app_service_key].name
  app_service_plan_id = azurerm_app_service_plan.demo.id

  identity {
    type = each.value.slot_identity
  }

}


````

## Apply the configuration

````
terraform validate
terraform fmt -recursive
terraform apply

````