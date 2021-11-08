# Managing Terraform State In Azure Blob Storage


## Add backends.tf file

Make sure to change the storage key

Content:

````
terraform {
    backend "azurerm" {
      resource_group_name = "<resource group name>"
      storage_account_name = "<storage account name>"
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

The tenant id and subscription id can be retrieved via the Azure CLI

````
az account show
````

Content:

````
azure_tenant_id = "<tenant id>"

azure_subscription_id = "<subscription id>"
````
## SAS Token
A SAS Token can be used to access the shared state storage in Azure.

### Create a SAS Token in the Azure Portal

### Initialize Terraform using the token

````
terraform init --backend-config="sas_token=?...." -reconfigure
````

## Access Key

Instead of a SAS Token an access key can be used to access the shared state storage in Azure.

Store the access key as an environment variable:

````
RESOURCE_GROUP_NAME=<resource group name>
STORAGE_ACCOUNT_NAME=<storage account name>

ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
export ARM_ACCESS_KEY=$ACCOUNT_KEY

terraform init
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