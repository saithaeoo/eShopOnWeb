param webAppName string
param sku string = 'B1'
param location string

var appServicePlanName = toLower('AppServicePlan-${webAppName}')

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  kind: 'linux' // ✅ Required for Linux plans
  properties: {
    reserved: true
  }
  sku: {
    name: sku
    tier: 'Basic' // ✅ Explicit tier for B1
  }
}

resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  kind: 'app,linux'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|8.0'
      appSettings: [
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: 'Development'
        }
        {
          name: 'UseOnlyInMemoryDatabase'
          value: 'true'
        }
      ]
    }
  }
}
