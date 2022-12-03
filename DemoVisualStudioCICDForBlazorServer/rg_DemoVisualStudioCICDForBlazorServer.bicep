param sites_web3DemoVisualStudioCICDForBlazorServer_name string
param serverfarms_plan_demovisualstudiocicdforblazorserver_name string
param registries_demovisualstudiocicdforblazorserver_name string
param loc string = resourceGroup().location

resource registries_demovisualstudiocicdforblazorserver_name_resource 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: registries_demovisualstudiocicdforblazorserver_name
  location: loc
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
    policies: {
      quarantinePolicy: {
        status: 'disabled'
      }
      trustPolicy: {
        type: 'Notary'
        status: 'disabled'
      }
      retentionPolicy: {
        days: 7
        status: 'disabled'
      }
      exportPolicy: {
        status: 'enabled'
      }
      azureADAuthenticationAsArmPolicy: {
        status: 'enabled'
      }
      softDeletePolicy: {
        retentionDays: 7
        status: 'disabled'
      }
    }
    encryption: {
      status: 'disabled'
    }
    dataEndpointEnabled: false
    publicNetworkAccess: 'Enabled'
    networkRuleBypassOptions: 'AzureServices'
    zoneRedundancy: 'Disabled'
    anonymousPullEnabled: false
  }
}

resource serverfarms_plan_demovisualstudiocicdforblazorserver_name_resource 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: serverfarms_plan_demovisualstudiocicdforblazorserver_name
  location: loc
  sku: {
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    family: 'B'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    freeOfferExpirationTime: '2022-12-26T06:15:29.18Z'
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource sites_web3DemoVisualStudioCICDForBlazorServer_name_resource 'Microsoft.Web/sites@2022-03-01' = {
  name: sites_web3DemoVisualStudioCICDForBlazorServer_name
  location: loc
  kind: 'app,linux,container'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: 'web3demovisualstudiocicdforblazorserver.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: 'web3demovisualstudiocicdforblazorserver.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_plan_demovisualstudiocicdforblazorserver_name_resource.id
    reserved: true
    isXenon: false
    hyperV: false
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      linuxFxVersion: 'DOCKER|demovisualstudiocicdforblazorserver.azurecr.io/sample/imagedemovisualstudiocicdforblazorserver:v1'
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: true
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: true
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

resource sites_web3DemoVisualStudioCICDForBlazorServer_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-03-01' = {
  parent: sites_web3DemoVisualStudioCICDForBlazorServer_name_resource
  name: 'ftp'
  properties: {
    allow: true
  }
}

resource sites_web3DemoVisualStudioCICDForBlazorServer_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-03-01' = {
  parent: sites_web3DemoVisualStudioCICDForBlazorServer_name_resource
  name: 'scm'
  properties: {
    allow: true
  }
}

resource sites_web3DemoVisualStudioCICDForBlazorServer_name_web 'Microsoft.Web/sites/config@2022-03-01' = {
  parent: sites_web3DemoVisualStudioCICDForBlazorServer_name_resource
  name: 'web'

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
    linuxFxVersion: 'DOCKER|demovisualstudiocicdforblazorserver.azurecr.io/sample/imagedemovisualstudiocicdforblazorserver:v1'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    remoteDebuggingVersion: 'VS2019'
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$web3DemoVisualStudioCICDForBlazorServer'
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
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: true
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'AllAllowed'
    preWarmedInstanceCount: 0
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 0
    azureStorageAccounts: {
    }
  }
}

resource sites_web3DemoVisualStudioCICDForBlazorServer_name_sites_web3DemoVisualStudioCICDForBlazorServer_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2022-03-01' = {
  parent: sites_web3DemoVisualStudioCICDForBlazorServer_name_resource
  name: '${sites_web3DemoVisualStudioCICDForBlazorServer_name}.azurewebsites.net'
  properties: {
    siteName: 'web3DemoVisualStudioCICDForBlazorServer'
    hostNameType: 'Verified'
  }
}
