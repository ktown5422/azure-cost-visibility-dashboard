// Subscription-scope entrypoint for the Cost Visibility Lab.
// Deploy with:
//   az deployment sub create --location <region> \
//     --template-file infra/main.bicep --parameters infra/main.parameters.json
targetScope = 'subscription'

@description('Name of the resource group to create for this lab.')
param resourceGroupName string = 'rg-cost-visibility-lab-iac'

@description('Azure region for the resource group and storage account.')
param location string

@description('Tags applied to the resource group, mirroring the portal-built version.')
param tags object = {
  project: 'cost-visibility-lab'
  env: 'lab'
}

@description('Email address to notify on budget alerts.')
param alertEmail string

@description('Monthly budget amount in the subscription billing currency.')
param budgetAmount int = 15

@description('Globally unique storage account name for the cost export destination.')
@minLength(3)
@maxLength(24)
param exportStorageAccountName string

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

module actionGroup 'modules/actionGroup.bicep' = {
  name: 'actionGroupDeploy'
  scope: rg
  params: {
    alertEmail: alertEmail
  }
}

module budget 'modules/budget.bicep' = {
  name: 'budgetDeploy'
  scope: rg
  params: {
    budgetAmount: budgetAmount
    actionGroupId: actionGroup.outputs.actionGroupId
  }
}

module exportStorage 'modules/exportStorage.bicep' = {
  name: 'exportStorageDeploy'
  scope: rg
  params: {
    location: location
    storageAccountName: exportStorageAccountName
  }
}

output resourceGroupName string = rg.name
output actionGroupId string = actionGroup.outputs.actionGroupId
output storageAccountName string = exportStorage.outputs.storageAccountName
