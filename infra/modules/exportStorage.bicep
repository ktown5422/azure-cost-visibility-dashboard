// Storage account + container for Cost Management exports, plus the
// export job itself. The Microsoft.CostManagement/exports API has moved
// across several preview versions — if this resource fails to deploy,
// check the current schema with:
//   az provider show --namespace Microsoft.CostManagement --query "resourceTypes[?resourceType=='exports']"
// and adjust apiVersion/properties below. See docs/setup-steps.md Module 5.
@description('Azure region for the storage account.')
param location string

@description('Globally unique storage account name.')
@minLength(3)
@maxLength(24)
param storageAccountName string

@description('Blob container that receives exported cost data.')
param containerName string = 'cost-exports'

@description('Name of the cost export job.')
param exportName string = 'export-cost-visibility-lab'

@description('Export schedule start, UTC. utcNow() defaults can only be set on a parameter, not inline.')
param exportStartDate string = utcNow('yyyy-MM-ddT00:00:00Z')

var exportEndDate = dateTimeAdd(exportStartDate, 'P1Y')

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  parent: storageAccount
  name: 'default'
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobService
  name: containerName
}

resource costExport 'Microsoft.CostManagement/exports@2023-08-01' = {
  name: exportName
  scope: resourceGroup()
  properties: {
    schedule: {
      status: 'Active'
      recurrence: 'Daily'
      recurrencePeriod: {
        from: exportStartDate
        to: exportEndDate
      }
    }
    format: 'Csv'
    deliveryInfo: {
      destination: {
        resourceId: storageAccount.id
        container: container.name
        rootFolderPath: 'cost-exports'
      }
    }
    definition: {
      type: 'ActualCost'
      timeframe: 'MonthToDate'
      dataSet: {
        granularity: 'Daily'
      }
    }
  }
}

output storageAccountName string = storageAccount.name
output containerName string = container.name
