// ==============================================================================
// Bicep IaC template
// Deploy a Function App using Linux App Service and consumption plan
// ==============================================================================

targetScope = 'subscription'

@description('Name used for resource group, and default base name for all resources')
param appName string

@description('Azure region for all resources')
param location string = deployment().location

// ===== Modules & Resources ==================================================

resource resGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: appName
  location: location
}

module storageAcct 'bicep-iac/modules/storage/account.bicep' = {
  name: 'storageAcct'
  scope: resGroup
  params: {
    name: appName
    location: location
  }
}

module appSvcPlan 'bicep-iac/modules/web/svc-plan-linux.bicep' = {
  name: 'appSvcPlan'
  scope: resGroup
  params: {
    name: appName
    location: location
    // Consumption plan
    sku: 'Y1'
  }
}

module appInsights 'bicep-iac/modules/monitoring/app-insights.bicep' = {
  name: 'appInsights'
  scope: resGroup
  params: {
    name: appName
    location: location
  }
}

module functionApp 'bicep-iac/modules/web/function-app-basic.bicep' = {
  name: 'functionApp'
  scope: resGroup
  params: {
    name: appName
    location: location
    storageAccountName: storageAcct.outputs.name
    storageAccountKey: storageAcct.outputs.accountKey
    servicePlanId: appSvcPlan.outputs.resourceId
    appInsightsKey: appInsights.outputs.instrumentationKey

    // Our app is using Node
    runtime: 'node'
    runtimeVersion: '18'
  }
}

output functionAppUrl string = 'https://${functionApp.outputs.hostname}.azurewebsites.net'
output functionAppName string = functionApp.outputs.name
