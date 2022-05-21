param sites_DockerDeployDemo003_name string = 'DockerDeployDemo003'
param serverfarms_Basic_ASP_externalid string = '/subscriptions/acc26051-92a5-4ed1-a226-64a187bc27db/resourceGroups/rg_/providers/Microsoft.Web/serverfarms/Basic-ASP'
@description('Creates a new site')
@secure()
param dockerPassword string
param dockerUsername string = 'siegfried01'

resource sites_DockerDeployDemo003_name_resource 'Microsoft.Web/sites@2021-03-01' = {
  name: sites_DockerDeployDemo003_name
  location: 'West US'
  kind: 'app,linux,container'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: 'dockerdeploydemo003.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: 'dockerdeploydemo003.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_Basic_ASP_externalid
    reserved: true
    isXenon: false
    hyperV: false
    siteConfig: {
        appSettings: [
          {
            name: 'DOCKER_REGISTRY_SERVER_USERNAME'
            value: dockerUsername
          }
          {
            name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
            value: dockerPassword
          }
          {
            name: 'DOCKER_REGISTRY_SERVER_URL' 
            value: 'https://index.docker.io/v1/'
          }
        ]      
      numberOfWorkers: 1
      linuxFxVersion: 'DOCKER|demovisualstudiocicdforblazorserver'
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      ipSecurityRestrictions: [
        {
          ipAddress: 'Any'
          action: 'Allow'
          priority: 1
          name: 'Allow all'
          description: 'Allow all access'
        }
      ]
      scmIpSecurityRestrictions: [
        {
          ipAddress: 'Any'
          action: 'Allow'
          priority: 1
          name: 'Allow all'
          description: 'Allow all access'
        }
      ]
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    customDomainVerificationId: '40BF7B86C2FCFDDFCAF1DB349DF5DEE2661093DBD1F889FA84ED4AAB4DA8B993'
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: false
    redundancyMode: 'None'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource sites_DockerDeployDemo003_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2021-03-01' = {
  parent: sites_DockerDeployDemo003_name_resource
  name: 'ftp'
  location: 'West US'
  properties: {
    allow: true
  }
}

resource sites_DockerDeployDemo003_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2021-03-01' = {
  parent: sites_DockerDeployDemo003_name_resource
  name: 'scm'
  location: 'West US'
  properties: {
    allow: true
  }
}

resource sites_DockerDeployDemo003_name_web 'Microsoft.Web/sites/config@2021-03-01' = {
  parent: sites_DockerDeployDemo003_name_resource
  name: 'web'
  location: 'West US'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
      'hostingstart.html'
    ]
    netFrameworkVersion: 'v4.0'
    linuxFxVersion: 'DOCKER|demovisualstudiocicdforblazorserver'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$DockerDeployDemo003'
    scmType: 'None'
    use32BitWorkerProcess: true
    webSocketsEnabled: false
    alwaysOn: false
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    localMySqlEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 1
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 1
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'AllAllowed'
    preWarmedInstanceCount: 0
    functionAppScaleLimit: 0
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 0
    azureStorageAccounts: {}
  }
}

resource sites_DockerDeployDemo003_name_sites_DockerDeployDemo003_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2021-03-01' = {
  parent: sites_DockerDeployDemo003_name_resource
  name: '${sites_DockerDeployDemo003_name}.azurewebsites.net'
  location: 'West US'
  properties: {
    siteName: 'DockerDeployDemo003'
    hostNameType: 'Verified'
  }
}
