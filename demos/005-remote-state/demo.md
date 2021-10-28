# Managing Terraform State In Azure Blob Storage


## Add backends.tf file

Make sure to change the storage key

Content:

````
terraform {
    backend "azurerm" {
      resource_group_name = "<resource group name>"
      storage_account_name = "<storage account name>"
      container_name = "<container name>"
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

The tenant id and subscription id can be retrieved via the Azure CLI

````
az account show
````

Content:

````
azure_tenant_id = "<tenant id"

azure_subscription_id = "<subscription id>"
````


## Create a SAS token to use when accessing the Azure Blob Storage

````
az storage container generate-sas \
    --account-name <storage-account> \
    --name <container> \
    --permissions rwdl \
    --expiry <date-time> \
    --auth-mode login \
    --as-user
````
## Initialize Terraform using the token

````
terraform init --backend-config="sas_token=?...."
````

## Apply the Terraform Configuration

````
terraform validate
terraform apply

````
## Clean Up

````
terraform destroy
````