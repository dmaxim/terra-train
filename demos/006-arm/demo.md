
# ARM Example

## Create a resource group

````

az group create -l eastus -n <resource-group-name>

````

## Create the resources

````
az deployment group validate --resource-group <resource-group-name> --template-file web-app.json

az deployment group whatif --resource-group <resource-group-name> --template-file web-app.json

az deployment group create --resource-group <resource-group-name> --template-file web-app.json

````

## Modify to add an app service

````
az deployment group create --resource-group <resource-group-name> --template-file web-app-modify.json
````

## Revise to remove the additional app service
````
az deployment group create --resource-group <resource-group-name> --template-file web-app.json --mode Complete
````
## Clean up

````
az deployment group delete --resource-group <resource-group-name> --template-file <path-to-template>
````