locals {
  app_services = {
    webjobs = {
      name = join("-", ["webjobs", var.namespace, var.environment])
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
      name = join("-", ["api", var.namespace, var.environment])
      slots = {
        dev = {
          name     = "dev"
          identity = "SystemAssigned"
        }
      }
    }
  }
}