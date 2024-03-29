
/**
   Begin common prolog commands
   export name=DemoVisualStudioCICDForBlazorServer
   export registry=`perl -e '$_ = shift; print lc;' $name`
   export image=image`perl -e '$_ = shift; print lc;' $name`
   export plan=plan_`perl -e '$_ = shift; print lc;' $name`
   export rg=rg_${name}
   export web=web3${name}
   export loc=westus
   End common prolog commands

   emacs F10
   Begin commands to execute this file using Azure CLI with bash
   echo WaitForBuildComplete
   WaitForBuildComplete
   echo "Previous build is complete. Begin deployment build."
   az deployment group create --name DemoVisualStudioCICDForBlazorServer --resource-group rg_DemoVisualStudioCICDForBlazorServer   --template-file deploy-DemoVisualStudioCICDForBlazorServer.bicep --parameters '@deploy.parameters.json'
   End commands to execute this file using Azure CLI with bash

   emacs ESC 2 F10
   Begin commands to shut down this deployment using Azure CLI with bash
   echo CreateBuildEvent.exe
   CreateBuildEvent.exe&
   echo "begin shutdown"
   az deployment group create --mode complete --template-file ./clear-resources.json --resource-group $rg
   BuildIsComplete.exe
   az resource list --query "[?resourceGroup=='$rg'].{ name: name, flavor: kind, resourceType: type, region: location }" --output table
   echo "showdown is complete"
   End commands to shut down this deployment using Azure CLI with bash

   emacs ESC 3 F10
   Begin commands for one time initializations using Azure CLI with bash
   az group create -l $loc -n $rg
   export id=`az group show --name $rg --query 'id' --output tsv`
   echo "id=$id"
   export sp="spad_$name"
   az ad sp create-for-rbac --name $sp --sdk-auth --role contributor --scopes $id
   echo "go to github settings->secrets and create a secret called AZURE_CREDENTIALS with the above output"
   export id=`az group show --name $rg --query 'id' --output tsv`
   cat >clear-resources.json <<EOF
   {
    "\$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
     "contentVersion": "1.0.0.0",
     "resources": [] 
   }
   EOF
   End commands for one time initializations using Azure CLI with bash


 */

/**
 * Begin commands to execute this file using Azure CLI with PowerShell
 * $name='DemoVisualStudioCICDForBlazorServer'
 * $rg="rg_$name"
 * az.cmd deployment group create --mode complete --template-file ./clear-resources.json --resource-group $rg
 * End commands to execute this file using Azure CLI with Powershell
 * 
 */

param appName  string  = 'demovisualstudiocicdforblazorserver'
param location string = resourceGroup().location
param location2 string = 'westus3'
param dockerhubAccount string = 'siegfried01'
param dockerhubPassword string
param tag string = 'latest'



@description('The base name for resources')
param name string = uniqueString(resourceGroup().id)


// https://stackoverflow.com/questions/57165359/how-to-deploy-a-private-docker-hub-image-to-an-azure-logic-app-using-the-create
/*
resource container 'Microsoft.ContainerInstance/containerGroups@2021-10-01' = {
  name: '${appName}web'
  location: location
  properties: {
    osType: 'Linux'
    imageRegistryCredentials:[
      {
        server: 'docker.io'
        username: dockerhubAccount
        password: dockerhubPassword
      }
    ]
    containers: [
      {
        name: 'webfrontend'
        properties: {          
          image: '${dockerhubAccount}/${appName}:${tag}'
          //image: '<acr-resource-name>.${imageRegistry}/${appName}:${tag}'
          ports: [
            {
              port: 80
              protocol: 'TCP'
            }
          ]
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 2
            }
          }
        }
      }
    ]
    ipAddress: {
      type: 'Public'
      dnsNameLabel: appName
      ports: [
        {
          port: 80
          protocol: 'TCP'
        }
      ]
    }
  }
}
*/

/*
@description('Generated from /subscriptions/acc26051-92a5-4ed1-a226-64a187bc27db/resourceGroups/rg_DemoVisualStudioCICDForBlazorServer/providers/Microsoft.ContainerInstance/containerGroups/demovisualstudiocicdforblazorserverweb')
resource demovisualstudiocicdforblazorserverweb 'Microsoft.ContainerInstance/containerGroups@2021-10-01' = {
  properties: {
    sku: 'Standard'
    containers: [
      {
        name: 'webfrontend'
        properties: {
          image: '${dockerhubAccount}/${appName}:${tag}'
          ports: [
            {
              protocol: 'TCP'
              port: 80
            }
          ]
          environmentVariables: []
          resources: {
            requests: {
              memoryInGB: 1
              cpu: 1
            }
          }
        }
      }
    ]
    initContainers: []
    imageRegistryCredentials: [
      {
        server: 'docker.io'
        username: dockerhubAccount
        password: dockerhubPassword
      }
    ]
    ipAddress: {
      ports: [
        {
          protocol: 'TCP'
          port: 80
        }
      ]
      type: 'Public'
      dnsNameLabel: 'demovisualstudiocicdforblazorserver'
      //autoGeneratedDomainNameLabelScope: 'Unsecure'
    }
    osType: 'Linux'
  }
  name: 'demovisualstudiocicdforblazorserverweb'
  location: location2
}
*/
// see https://robertchambers.co/2021/09/azure-bicep-webapp/ "linuxFxVersion": "DOCKER|mcr.microsoft.com/appsvc/staticsite:latest",
// see https://github.com/MicrosoftDocs/azure-docs/issues/36505  "linuxFxVersion": "DOCKER|<myRegistry>.azurecr.io/<myTag>",
// see https://docs.microsoft.com/en-us/azure/templates/microsoft.web/sites?tabs=bicep Microsoft.Web Sites
// see https://github.com/siegfried01/DemoVisualStudioCICDForBlazorServer001/actions workflows
// see https://stackoverflow.com/questions/63744842/azure-cli-delete-resource-without-deleting-resource-group delete resource groups az deployment group create --mode complete --template-uri data:application/json,%7B%22%24schema%22%3A%22https%3A%2F%2Fschema.management.azure.com%2Fschemas%2F2019-04-01%2FdeploymentTemplate.json%23%22%2C%22contentVersion%22%3A%221.0.0.0%22%2C%22resources%22%3A%5B%5D%7D --name clear-resources --resource-group <RG_NAME>
// Container groups contain no logging features: https://docs.microsoft.com/en-us/azure/templates/microsoft.containerinstance/containergroups?tabs=bicep
// Web Apps deploy from registry: https://github.com/MicrosoftDocs/azure-docs/issues/36505
// working example that uses ACR (not dockerhub) https://github.com/jamiemccrindle/bicep-app-service-container/blob/main/.github/workflows/deploy.yml
// dockerhub explicit example:  https://stackoverflow.com/questions/57165359/how-to-deploy-a-private-docker-hub-image-to-an-azure-logic-app-using-the-create -> https://github.com/MicrosoftDocs/azure-docs/issues/9799#issuecomment-397389055
/*
Error messages when deploying a docker image to App Service:

2022-05-20T21:50:35.914Z ERROR - DockerApiException: Docker API responded with status code=NotFound, response={"message":"pull access denied for demovisualstudiocicdforblazorserver, repository does not exist or may require 'docker login': denied: requested access to the resource is denied"}
2022-05-20T21:50:35.915Z ERROR - Pulling docker image docker.io/demovisualstudiocicdforblazorserver failed:
2022-05-20T21:50:35.916Z WARN  - Image pull failed. Defaulting to local copy if present.
2022-05-20T21:50:35.923Z ERROR - Image pull failed: Verify docker image configuration and credentials (if using private repository)
2022-05-20T21:50:35.928Z INFO  - Stopping site dockerdeploydemo003 because it failed during startup.
/home/LogFiles/2022_05_20_lw1sdlwk000FX5_docker.log  (https://dockerdeploydemo003.scm.azurewebsites.net/api/vfs/LogFiles/2022_05_20_lw1sdlwk000FX5_docker.log)
2022-05-20T21:35:47.559Z WARN  - Image pull failed. Defaulting to local copy if present.
2022-05-20T21:35:47.562Z ERROR - Image pull failed: Verify docker image configuration and credentials (if using private repository)

This wokred, however:
az.cmd webapp create  --name DockerhubDeployDemo004  --resource-group  rg_  --plan Basic-ASP -s siegfried01 -w topsecrete --deployment-container-image-name siegfried01/demovisualstudiocicdforblazorserver


*/

@description('The web site hosting plan')
@allowed([
  'F1'
  'D1'
  'B1'
  'B2'
  'B3'
  'S1'
  'S2'
  'S3'
  'P1'
  'P2'
  'P3'
  'P4'
])
param webPlanSku string = 'F1'
@description('The location for resources')

resource plan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: '${name}-plan'
  location: location
  sku: {
    name: webPlanSku
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource web 'Microsoft.Web/sites@2020-12-01' = {
  name: '${name}-web'
  location: location
  properties: {
    httpsOnly: true // https://stackoverflow.com/questions/54534924/arm-template-for-to-configure-app-services-with-new-vnet-integration-feature/59857601#59857601
    serverFarmId: plan.id // it should look like /subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.Network/virtualNetworks/{vnetName}/subnets/{subnetName}
    siteConfig: {
      linuxFxVersion: 'DOCKER|siegfried01/demovisualstudiocicdforblazorserver:latest'
    }
  }

  resource logs 'config' = {
    name: 'logs'
    properties: {
      applicationLogs: {
        fileSystem: {
          level: 'Warning'
        }
      }
      httpLogs: {
        fileSystem: {
          enabled: true
        }
      }
      detailedErrorMessages: {
        enabled: true
      }
    }
  }
}
var appConfigNew = {
  DOCKER_ENABLE_CI: 'true'
  DOCKER_REGISTRY_SERVER_PASSWORD: dockerhubPassword
  DOCKER_REGISTRY_SERVER_URL: 'https://index.docker.io/v1/'
  DOCKER_REGISTRY_SERVER_USERNAME: dockerhubAccount
  TITLE: 'deployed via githb workflow, bicep & dockerhub'
}

resource appSettings 'Microsoft.Web/sites/config@2021-01-15' = {
  name: 'appsettings'
  parent: web
  properties: appConfigNew
}


// add Kubernetes Cluster too: https://docs.microsoft.com/en-us/learn/modules/aks-deploy-container-app/7-exercise-expose-app
