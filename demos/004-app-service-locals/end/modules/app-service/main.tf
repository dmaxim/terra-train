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
  for_each            = var.app_services
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
