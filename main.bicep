@sys.description('The Web App name.')
@minLength(3)
@maxLength(30)
param appServiceAppName1 string = 'app-prod-be'
@sys.description('The Web App name.')
@minLength(3)
@maxLength(30)
param appServiceAppName3 string = 'app-prod-fe'
@sys.description('The App Service Plan name.')
@minLength(3)
@maxLength(30)
param appServicePlanName1 string = 'app-prod'
@sys.description('The Web App name.')
@minLength(3)
@maxLength(30)
param appServiceAppName2 string = 'app-dev-be'
@minLength(3)
@maxLength(30)
param appServiceAppName4 string = 'app-dev-fe'
@sys.description('The App Service Plan name.')
@minLength(3)
@maxLength(30)
param appServicePlanName2 string = 'app-dev'
@allowed([
  'nonprod'
  'prod'
  ])
param environmentType string = 'nonprod'
param location string = resourceGroup().location
@secure()
param dbhost string
@secure()
param dbuser string
@secure()
param dbpass string
@secure()
param dbname string

param runtimestack_be string = 'python|3.10'
param runtimestack_fe string = 'Node|14-lts'
param startup_command string = 'pm2 serve /home/site/wwwroot/dist --no-daemon --spa'


module appService1 'modules/appStuff.bicep' = if (environmentType == 'prod') {
  name: 'appService1'
  params: { 
    location: location
    appServiceAppName: appServiceAppName1
    appServicePlanName: appServicePlanName1
    runtimeStack: runtimestack_be
    dbhost: dbhost
    dbuser: dbuser
    dbpass: dbpass
    dbname: dbname
  }
}

module appService3 'modules/appStuffFE.bicep' = if (environmentType == 'prod') {
  name: 'appService3'
  params: { 
    location: location
    appServiceAppName: appServiceAppName3
    appServicePlanName: appServicePlanName1
    runtimeStack: runtimestack_fe
    startupCommand: startup_command
    dbhost: dbhost
    dbuser: dbuser
    dbpass: dbpass
    dbname: dbname
  }
}

module appService2 'modules/appStuff.bicep' = if (environmentType == 'nonprod') {
  name: 'appService2'
  params: { 
    location: location
    appServiceAppName: appServiceAppName2
    appServicePlanName: appServicePlanName2
    runtimeStack: runtimestack_be
    dbhost: dbhost
    dbuser: dbuser
    dbpass: dbpass
    dbname: dbname
  }
}

module appService4 'modules/appStuffFE.bicep' = if (environmentType == 'nonprod') {
  name: 'appService4'
  params: { 
    location: location
    appServiceAppName: appServiceAppName4
    appServicePlanName: appServicePlanName2
    runtimeStack: runtimestack_fe
    startupCommand: startup_command
    dbhost: dbhost
    dbuser: dbuser
    dbpass: dbpass
    dbname: dbname
  }
}

  output appServiceAppHostName1 string = (environmentType == 'prod') ? appService1.outputs.appServiceAppHostName : appService2.outputs.appServiceAppHostName
  output appServiceAppHostName2 string = (environmentType == 'prod') ? appService3.outputs.appServiceAppHostName : appService4.outputs.appServiceAppHostName
