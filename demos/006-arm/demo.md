
# ARM Example

### Create a resource group


````

az group create -l eastus -n <resource-group-name>

````

### Create the resources

````
az deployment group create --resource-group <resource-group-name> --template-file <path-to-template>


````