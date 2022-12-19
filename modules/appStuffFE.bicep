param location string = resourceGroup().location
param appServiceAppName string
param appServicePlanName string
param runtimeStack string
param startupCommand string
param dbhost string
param dbuser string
param dbpass string
param dbname string

var appServicePlanSkuName = 'B1'

resource appServicePlan 'Microsoft.Web/serverFarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  kind: 'linux'
  properties: {
    reserved: true
  }
  sku: {
    name: appServicePlanSkuName
  }
}



resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
name: appServiceAppName
location: location
properties: {
  serverFarmId: appServicePlan.id
  httpsOnly: true
  siteConfig: {
    linuxFxVersion: runtimeStack
    appSettings: [
      {
        name: 'DBUSER'
        value: dbuser
      }
      {
        name: 'DBPASS'
        value: dbpass
      }
      {
        name: 'DBNAME'
        value: dbname
      }
      {
        name: 'DBHOST'
        value: dbhost
      }
      {
        name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
        value: 'true'
      }
      {
        name: 'ENABLE_ORYX_BUILD'
        value: 'true'
      }
    ]
    appCommandLine: startupCommand
  }
  }
}

output appServiceAppHostName string = appServiceApp.properties.defaultHostName
