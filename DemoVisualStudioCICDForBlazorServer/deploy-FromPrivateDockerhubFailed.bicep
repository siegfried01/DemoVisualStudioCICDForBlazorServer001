// https://foldr.uk/azure-bicep-app-service-custom-container/

/**
 * Begin commands to execute this file using Azure CLI with PowerShell
 * $name='DemoVisualStudioCICDForBlazorServer'
 * $rg="rg_$name"
 * $loc='westus2'
 * az.cmd deployment group create --name DemoVisualStudioCICDForBlazorServer --resource-group rg_DemoVisualStudioCICDForBlazorServer   --template-file deploy-FromPrivateDockerhubFailed.bicep --parameters '@deploy.parameters.json'
 * End commands to execute this file using Azure CLI with Powershell
 */

/**
 * Begin commands to execute this file using Azure CLI with PowerShell
 * $name='DemoVisualStudioCICDForBlazorServer'
 * $rg="rg_$name"
 * az.cmd deployment group create --mode complete --template-file ./clear-resources.json --resource-group $rg
 * az deployment group create --mode complete --template-uri data:application/json,%7B%22%24schema%22%3A%22https%3A%2F%2Fschema.management.azure.com%2Fschemas%2F2019-04-01%2FdeploymentTemplate.json%23%22%2C%22contentVersion%22%3A%221.0.0.0%22%2C%22resources%22%3A%5B%5D%7D --name clear-resources --resource-group $rg
 * End commands to execute this file using Azure CLI with Powershell
 *
 * 
 */

@description('Creates a new site')
@secure()
param dockerhubPassword string
param dockerUsername string = 'siegfried01'

@description('The base name for resources')
param name string = uniqueString(resourceGroup().id)

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
param location string = resourceGroup().location

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
  DOCKER_REGISTRY_SERVER_USERNAME: dockerUsername
}

resource appSettings 'Microsoft.Web/sites/config@2021-01-15' = {
  name: 'appsettings'
  parent: web
  properties: appConfigNew
}
