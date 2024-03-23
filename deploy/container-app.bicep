// ==============================================================================
// Bicep IaC template
// Deploy a Function App using Azure Container Apps
// ==============================================================================

targetScope = 'subscription'

@description('Name used for resource group, and default base name for all resources')
param appName string

param imageRegistry string = 'ghcr.io'
param imageTag string = 'latest'
param imageRepo string

@description('Azure region for all resources')
param location string = deployment().location

// ===== Modules & Resources ==================================================

resource resGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: appName
  location: location
}

module logAnalytics './bicep-iac/modules/monitoring/log-analytics.bicep' = {
  scope: resGroup
  name: 'monitoring'
  params: {
    location: location
    name: 'logs'
  }
}

module containerAppEnv './bicep-iac/modules/containers/app-env.bicep' = {
  scope: resGroup
  name: 'containerAppEnv'
  params: {
    location: location
    name: 'app-environment'
    logAnalyticsName: logAnalytics.outputs.name
    logAnalyticsResGroup: resGroup.name
  }
}

module storageAcct 'bicep-iac/modules/storage/account.bicep' = {
  name: 'storageAcct'
  scope: resGroup
  params: {
    name: appName
    location: location
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

module functionApp 'bicep-iac/modules/web/function-app-container.bicep' = {
  name: 'functionApp'
  scope: resGroup
  params: {
    name: appName
    location: location

    storageAccountName: storageAcct.outputs.name
    storageAccountKey: storageAcct.outputs.accountKey
    containerAppsEnvId: containerAppEnv.outputs.id
    appInsightsKey: appInsights.outputs.instrumentationKey

    // These change per project
    repo: imageRepo
    tag: imageTag
    registry: imageRegistry
  }
}
