# Creating a resource group with Terraform

## Login via the Azure CLI

````
az login

````

Verify you are connected to the subscription where you will create resources:

````
az account show
````

If you are not connected to the correct subscription:

````
az account list

az account set --subscription "<subscription name>"
````

## Create the Terraform files

### main.tf
### variables.tf

### providers.tf
Content

````
provider "azurerm" {
  features {}
}
````

### versions.tf

Content

````
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
  required_version = ">= 1.0"
}

````

## Initialize Terraform

````
terraform init
````

## Add the Resource Group Definition to the main.tf file

Content:

````

resource "azurerm_resource_group" "demo" {
    name = join("-", ["rg", var.namespace, var.environment])
    location = var.location
    
    tags = {
        environment = var.environment
    }
}
````

## Add the required variable definitions to the variables.tf file

Content:

````

variable "namespace" {
    type = string
    description = "The namespace to use in all resources"
}


variable "location" {
    type = string
    description = "Azure region where the resources will be created"
    default = "eastus"
}


variable "environment" {
    type = string
    description = "Environment that will be included in resource names and tags"
    default = "demo"
}
````


## Validate the configuration

````
terraform validate
````

## Format the configuration

````
terraform fmt
````

## Preview the changes
````
terraform plan
````


## Apply the changes
````
terraform apply
````

## Clean up

````
terraform destroy
````



