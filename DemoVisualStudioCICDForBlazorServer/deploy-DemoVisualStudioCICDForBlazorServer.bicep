
/**
 * Begin commands to execute this file using Azure CLI with PowerShell
 * $name='DemoVisualStudioCICDForBlazorServer'
 * $rg="rg_$name"
 * $loc='westus2'
 * az.cmd deployment group create --name DemoVisualStudioCICDForBlazorServer --resource-group rg_DemoVisualStudioCICDForBlazorServer   --template-file deploy-DemoVisualStudioCICDForBlazorServer.bicep --parameters '@deploy.parameters.json'
 * End commands to execute this file using Azure CLI with Powershell
 */

/**
 * Begin commands to execute this file using Azure CLI with PowerShell
 * $name='DemoVisualStudioCICDForBlazorServer'
 * $rg="rg_$name"
 * #az resource list --resource-group $rg | ConvertFrom-Json | Foreach-Object {az resource delete --resource-group $rg --ids $_.id --verbose}
 * az deployment group create --mode complete --template-uri data:application/json,%7B%22%24schema%22%3A%22https%3A%2F%2Fschema.management.azure.com%2Fschemas%2F2019-04-01%2FdeploymentTemplate.json%23%22%2C%22contentVersion%22%3A%221.0.0.0%22%2C%22resources%22%3A%5B%5D%7D --name clear-resources --resource-group $rg
 * End commands to execute this file using Azure CLI with Powershell
 */

param appName  string  = 'demovisualstudiocicdforblazorserver'
param location string = resourceGroup().location
param dockerAccount string = 'siegfried01'
@secure()
param dockerhubPassword string
param tag string = 'latest'

/*
resource registry 'Microsoft.ContainerRegistry/registries@2021-12-01-preview' = {
  name: '${appName}registry'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    adminUserEnabled: true
  }
}
*/

// https://stackoverflow.com/questions/57165359/how-to-deploy-a-private-docker-hub-image-to-an-azure-logic-app-using-the-create
resource container 'Microsoft.ContainerInstance/containerGroups@2021-10-01' = {
  name: '${appName}web'
  location: location
  properties: {
    osType: 'Linux'
    imageRegistryCredentials:[
      {
        server: 'docker.io'
        username: dockerAccount
        password: dockerhubPassword
      }
    ]
    containers: [
      {
        name: 'webfrontend'
        properties: {          
          image: '${dockerAccount}/${appName}:${tag}'
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
