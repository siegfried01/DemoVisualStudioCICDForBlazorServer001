/*


   // https://learn.microsoft.com/en-us/azure/app-service/tutorial-custom-container?pivots=container-linux
   // https://learn.microsoft.com/en-us/azure/container-registry/container-registry-quickstart-task-cli#build-and-push-image-from-a-dockerfile
   // https://learn.microsoft.com/en-us/cli/azure/acr?view=azure-cli-latest#az-acr-build
   // https://learn.microsoft.com/en-us/cli/azure/webapp?view=azure-cli-latest#az-webapp-create
   // https://learn.microsoft.com/en-us/azure/container-registry/container-registry-get-started-docker-cli?tabs=azure-cli

   Begin common prolog commands
   export APPSERVICE_SKU=FREE
   export name=DemoVisualStudioCICDForBlazorServer
   export plan=2j6dkjc5s4m4q-plan
   export rg=rg_${name} 
   export WEB=2j6dkjc5s4m4q-web
   export loc=westus
   export DOCKERHUB_USERNAME=siegfried01
   export DOCKERHUB_REPO=demovisualstudiocicdforblazorserver
   export DOCKER_IMAGE=demovisualstudiocicdforblazorserver
   End common prolog commands

   emacs F10
   Begin commands to deploy this file using Azure CLI with bash
   echo WaitForBuildComplete
   WaitForBuildComplete
   echo "Previous build is complete. Begin deployment build."
   echo docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD
   docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD
   echo docker build -t $DOCKER_IMAGE:v1 .
   docker build -t $DOCKER_IMAGE:v1 .
   echo docker tag $DOCKER_IMAGE:v1 $DOCKERHUB_USERNAME/$DOCKER_IMAGE:v1
   docker tag $DOCKER_IMAGE:v1 $DOCKERHUB_USERNAME/$DOCKER_IMAGE:v1
   echo docker push $DOCKERHUB_USERNAME/$DOCKER_IMAGE:v1
   docker push $DOCKERHUB_USERNAME/$DOCKER_IMAGE:v1
   az resource list -g $rg --query "[?resourceGroup=='$rg'].{ name: name, flavor: kind, resourceType: type, region: location }" --output table
   End commands to deploy this file using Azure CLI with bash

   emacs ESC 2 F10
   Begin commands to shut down this deployment using Azure CLI with bash
   echo CreateBuildEvent.exe
   CreateBuildEvent.exe&
   echo "begin shutdown"
   az deployment group create --mode complete --template-file ./clear-resources.json --resource-group $rg
   BuildIsComplete.exe
   echo list resources for $rg
   az resource list --query "[?resourceGroup=='$rg'].{ name: name, flavor: kind, resourceType: type, region: location }" --output table
   echo "showdown is complete"
   End commands to shut down this deployment using Azure CLI with bash

   emacs ESC 3 F10
   Begin commands for one time initializations using Azure CLI with bash
   az group create -l $loc -n $rg
   export id=`az group show --name $rg --query 'id' --output tsv`
   echo "id=$id"
   export sp="spad_$name"
   #az ad sp create-for-rbac --name $sp --sdk-auth --role contributor --scopes $id
   #echo "go to github settings->secrets and create a secret called AZURE_CREDENTIALS with the above output"
   cat >clear-resources.json <<EOF
   {
    "\$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
     "contentVersion": "1.0.0.0",
     "resources": [] 
   }
   EOF
   End commands for one time initializations using Azure CLI with bash

   emacs ESC 4 F10
   Begin commands to deploy this file using Azure CLI with bash
   echo WaitForBuildComplete
   WaitForBuildComplete
   echo az appservice plan create --name $plan --is-linux  --resource-group $rg  --sku $APPSERVICE_SKU
   az appservice plan create --name $plan --is-linux  --resource-group $rg  --sku $APPSERVICE_SKU
   echo az webapp create  --name $WEB --resource-group  $rg  --plan $plan --deployment-container-image-name $DOCKERHUB_USERNAME/$DOCKER_IMAGE:v1 -s $DOCKERHUB_USERNAME -w $DOCKERHUB_PASSWORD
   az webapp create  --name $WEB --resource-group  $rg  --plan $plan --deployment-container-image-name $DOCKERHUB_USERNAME/$DOCKER_IMAGE:v1 -s $DOCKERHUB_USERNAME -w $DOCKERHUB_PASSWORD
   #az webapp config appsettings set  --resource-group $rg  --name $WEB  --settings  "TITLE=Deployed via Azure CLI and Dockerhub"
   az resource list -g $rg --query "[?resourceGroup=='$rg'].{ name: name, flavor: kind, resourceType: type, region: location }" --output table
   End commands to deploy this file using Azure CLI with bash

   emacs ESC 5 F10
   Begin commands to deploy this file using Azure CLI with bash
   echo az webapp delete --name $WEB --resource-group $rg --keep-empty-plan
   az webapp delete --name $WEB --resource-group $rg --keep-empty-plan
   End commands to deploy this file using Azure CLI with bash

   emacs ESC 6 F10
   Begin commands to deploy this file using Azure CLI with bash
   echo az webapp config container show --name $WEB --resource-group $rg 
   az webapp config container show --name $WEB --resource-group $rg 
   End commands to deploy this file using Azure CLI with bash
*/



//   WaitForBuildComplete
//   No Build in Progress
//   az appservice plan create --name 2j6dkjc5s4m4q-plan --is-linux --resource-group rg_DemoVisualStudioCICDForBlazorServer --sku FREE
//   {
//     "elasticScaleEnabled": false,
//     "extendedLocation": null,
//     "freeOfferExpirationTime": null,
//     "geoRegion": "West US",
//     "hostingEnvironmentProfile": null,
//     "hyperV": false,
//     "id": "/subscriptions/acc26051-92a5-4ed1-a226-64a187bc27db/resourceGroups/rg_DemoVisualStudioCICDForBlazorServer/providers/Microsoft.Web/serverfarms/2j6dkjc5s4m4q-plan",
//     "isSpot": false,
//     "isXenon": false,
//     "kind": "linux",
//     "kubeEnvironmentProfile": null,
//     "location": "westus",
//     "maximumElasticWorkerCount": 1,
//     "maximumNumberOfWorkers": 1,
//     "name": "2j6dkjc5s4m4q-plan",
//     "numberOfSites": 0,
//     "numberOfWorkers": 1,
//     "perSiteScaling": false,
//     "provisioningState": "Succeeded",
//     "reserved": true,
//     "resourceGroup": "rg_DemoVisualStudioCICDForBlazorServer",
//     "sku": {
//       "capabilities": null,
//       "capacity": 1,
//       "family": "F",
//       "locations": null,
//       "name": "F1",
//       "size": "F1",
//       "skuCapacity": null,
//       "tier": "Free"
//     },
//     "spotExpirationTime": null,
//     "status": "Ready",
//     "subscription": "acc26051-92a5-4ed1-a226-64a187bc27db",
//     "tags": null,
//     "targetWorkerCount": 0,
//     "targetWorkerSizeId": 0,
//     "type": "Microsoft.Web/serverfarms",
//     "workerTierName": null,
//     "zoneRedundant": false
//   }
//   az webapp create --name 2j6dkjc5s4m4q-web --resource-group rg_DemoVisualStudioCICDForBlazorServer --plan 2j6dkjc5s4m4q-plan --deployment-container-image-name siegfried01/demovisualstudiocicdforblazorserver:1 -s siegfried01 -w Master1971Blaster
//   {
//     "availabilityState": "Normal",
//     "clientAffinityEnabled": true,
//     "clientCertEnabled": false,
//     "clientCertExclusionPaths": null,
//     "clientCertMode": "Required",
//     "cloningInfo": null,
//     "containerSize": 0,
//     "customDomainVerificationId": "40BF7B86C2FCFDDFCAF1DB349DF5DEE2661093DBD1F889FA84ED4AAB4DA8B993",
//     "dailyMemoryTimeQuota": 0,
//     "defaultHostName": "2j6dkjc5s4m4q-web.azurewebsites.net",
//     "enabled": true,
//     "enabledHostNames": [
//       "2j6dkjc5s4m4q-web.azurewebsites.net",
//       "2j6dkjc5s4m4q-web.scm.azurewebsites.net"
//     ],
//     "extendedLocation": null,
//     "ftpPublishingUrl": "ftp://waws-prod-bay-151.ftp.azurewebsites.windows.net/site/wwwroot",
//     "hostNameSslStates": [
//       {
//         "hostType": "Standard",
//         "ipBasedSslResult": null,
//         "ipBasedSslState": "NotConfigured",
//         "name": "2j6dkjc5s4m4q-web.azurewebsites.net",
//         "sslState": "Disabled",
//         "thumbprint": null,
//         "toUpdate": null,
//         "toUpdateIpBasedSsl": null,
//         "virtualIp": null
//       },
//       {
//         "hostType": "Repository",
//         "ipBasedSslResult": null,
//         "ipBasedSslState": "NotConfigured",
//         "name": "2j6dkjc5s4m4q-web.scm.azurewebsites.net",
//         "sslState": "Disabled",
//         "thumbprint": null,
//         "toUpdate": null,
//         "toUpdateIpBasedSsl": null,
//         "virtualIp": null
//       }
//     ],
//     "hostNames": [
//       "2j6dkjc5s4m4q-web.azurewebsites.net"
//     ],
//     "hostNamesDisabled": false,
//     "hostingEnvironmentProfile": null,
//     "httpsOnly": false,
//     "hyperV": false,
//     "id": "/subscriptions/acc26051-92a5-4ed1-a226-64a187bc27db/resourceGroups/rg_DemoVisualStudioCICDForBlazorServer/providers/Microsoft.Web/sites/2j6dkjc5s4m4q-web",
//     "identity": null,
//     "inProgressOperationId": null,
//     "isDefaultContainer": null,
//     "isXenon": false,
//     "keyVaultReferenceIdentity": "SystemAssigned",
//     "kind": "app,linux,container",
//     "lastModifiedTimeUtc": "2022-12-20T21:55:24.780000",
//     "location": "West US",
//     "maxNumberOfWorkers": null,
//     "name": "2j6dkjc5s4m4q-web",
//     "outboundIpAddresses": "13.91.137.115,13.91.137.162,13.91.137.189,13.91.137.194,13.91.137.210,13.91.138.6,40.82.255.130",
//     "possibleOutboundIpAddresses": "13.91.137.115,13.91.137.162,13.91.137.189,13.91.137.194,13.91.137.210,13.91.138.6,13.91.138.10,13.91.138.48,13.91.138.79,13.91.138.81,13.91.138.87,13.91.138.91,52.234.92.223,52.234.93.29,52.234.93.65,52.234.93.112,52.234.93.153,52.234.94.28,13.64.112.235,168.62.202.7,138.91.188.218,13.64.119.219,13.64.119.144,13.64.119.184,40.82.255.130",
//     "publicNetworkAccess": null,
//     "redundancyMode": "None",
//     "repositorySiteName": "2j6dkjc5s4m4q-web",
//     "reserved": true,
//     "resourceGroup": "rg_DemoVisualStudioCICDForBlazorServer",
//     "scmSiteAlsoStopped": false,
//     "serverFarmId": "/subscriptions/acc26051-92a5-4ed1-a226-64a187bc27db/resourceGroups/rg_DemoVisualStudioCICDForBlazorServer/providers/Microsoft.Web/serverfarms/2j6dkjc5s4m4q-plan",
//     "siteConfig": {
//       "acrUseManagedIdentityCreds": false,
//       "acrUserManagedIdentityId": null,
//       "alwaysOn": false,
//       "antivirusScanEnabled": null,
//       "apiDefinition": null,
//       "apiManagementConfig": null,
//       "appCommandLine": null,
//       "appSettings": null,
//       "autoHealEnabled": null,
//       "autoHealRules": null,
//       "autoSwapSlotName": null,
//       "azureMonitorLogCategories": null,
//       "azureStorageAccounts": null,
//       "connectionStrings": null,
//       "cors": null,
//       "customAppPoolIdentityAdminState": null,
//       "customAppPoolIdentityTenantState": null,
//       "defaultDocuments": null,
//       "detailedErrorLoggingEnabled": null,
//       "documentRoot": null,
//       "elasticWebAppScaleLimit": 0,
//       "experiments": null,
//       "fileChangeAuditEnabled": null,
//       "ftpsState": null,
//       "functionAppScaleLimit": null,
//       "functionsRuntimeScaleMonitoringEnabled": null,
//       "handlerMappings": null,
//       "healthCheckPath": null,
//       "http20Enabled": false,
//       "http20ProxyFlag": null,
//       "httpLoggingEnabled": null,
//       "ipSecurityRestrictions": [
//         {
//           "action": "Allow",
//           "description": "Allow all access",
//           "headers": null,
//           "ipAddress": "Any",
//           "name": "Allow all",
//           "priority": 2147483647,
//           "subnetMask": null,
//           "subnetTrafficTag": null,
//           "tag": null,
//           "vnetSubnetResourceId": null,
//           "vnetTrafficTag": null
//         }
//       ],
//       "ipSecurityRestrictionsDefaultAction": null,
//       "javaContainer": null,
//       "javaContainerVersion": null,
//       "javaVersion": null,
//       "keyVaultReferenceIdentity": null,
//       "limits": null,
//       "linuxFxVersion": "",
//       "loadBalancing": null,
//       "localMySqlEnabled": null,
//       "logsDirectorySizeLimit": null,
//       "machineKey": null,
//       "managedPipelineMode": null,
//       "managedServiceIdentityId": null,
//       "metadata": null,
//       "minTlsCipherSuite": null,
//       "minTlsVersion": null,
//       "minimumElasticInstanceCount": 0,
//       "netFrameworkVersion": null,
//       "nodeVersion": null,
//       "numberOfWorkers": 1,
//       "phpVersion": null,
//       "powerShellVersion": null,
//       "preWarmedInstanceCount": null,
//       "publicNetworkAccess": null,
//       "publishingPassword": null,
//       "publishingUsername": null,
//       "push": null,
//       "pythonVersion": null,
//       "remoteDebuggingEnabled": null,
//       "remoteDebuggingVersion": null,
//       "requestTracingEnabled": null,
//       "requestTracingExpirationTime": null,
//       "routingRules": null,
//       "runtimeADUser": null,
//       "runtimeADUserPassword": null,
//       "scmIpSecurityRestrictions": [
//         {
//           "action": "Allow",
//           "description": "Allow all access",
//           "headers": null,
//           "ipAddress": "Any",
//           "name": "Allow all",
//           "priority": 2147483647,
//           "subnetMask": null,
//           "subnetTrafficTag": null,
//           "tag": null,
//           "vnetSubnetResourceId": null,
//           "vnetTrafficTag": null
//         }
//       ],
//       "scmIpSecurityRestrictionsDefaultAction": null,
//       "scmIpSecurityRestrictionsUseMain": null,
//       "scmMinTlsVersion": null,
//       "scmType": null,
//       "sitePort": null,
//       "storageType": null,
//       "supportedTlsCipherSuites": null,
//       "tracingOptions": null,
//       "use32BitWorkerProcess": null,
//       "virtualApplications": null,
//       "vnetName": null,
//       "vnetPrivatePortsCount": null,
//       "vnetRouteAllEnabled": null,
//       "webSocketsEnabled": null,
//       "websiteTimeZone": null,
//       "winAuthAdminState": null,
//       "winAuthTenantState": null,
//       "windowsConfiguredStacks": null,
//       "windowsFxVersion": null,
//       "xManagedServiceIdentityId": null
//     },
//     "slotSwapStatus": null,
//     "state": "Running",
//     "storageAccountRequired": false,
//     "suspendedTill": null,
//     "tags": null,
//     "targetSwapSlot": null,
//     "trafficManagerHostNames": null,
//     "type": "Microsoft.Web/sites",
//     "usageState": "Normal",
//     "virtualNetworkSubnetId": null,
//     "vnetContentShareEnabled": false,
//     "vnetImagePullEnabled": false,
//     "vnetRouteAllEnabled": false
//   }
//   Name                Flavor               ResourceType               Region
//   ------------------  -------------------  -------------------------  --------
//   2j6dkjc5s4m4q-plan  linux                Microsoft.Web/serverFarms  westus
//   2j6dkjc5s4m4q-web   app,linux,container  Microsoft.Web/sites        westus

//   Process compilation finished

