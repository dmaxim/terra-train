# Managing Terraform State In Azure Blob Storage


## Add backends.tf file

Make sure to change the storage key

Content:

````
terraform {
    backend "azurerm" {
      resource_group_name = "rg-dart-devops-dev"
      storage_account_name = "dartdevops"
      container_name = "demotf"
      key = "<yourname>.tfstate"
    }
}

````

## Add Variables for the Azure Configuration to the variables.tf file

````
variable "azure_tenant_id" {}

variable "azure_subscription_id" {}

````

## Update the providers.tf file to reference the new variables

Updated content:

````
#--- providers.tf ---#

provider "azurerm" {
  subscription_id = var.azure_subscription_id
  tenant_id = var.azure_tenant_id
  features {}
}

````

## Add variables.tfvars file 

## Create a SAS token to use when accessing the Azure Blob Storage

## Initialize Terraform using the token

## Apply the Terraform Configuration

````
terraform validate
terraform apply

````
## Clean Up

````
terraform destroy
````