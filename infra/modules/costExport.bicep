@description('Name of the Cost Management export')
param exportName string

@description('Resource ID of the storage account to deliver export files to')
param storageAccountId string

@description('Blob container that receives export files')
param containerName string = 'cost-exports'

@description('Recurrence window start, ISO 8601 datetime')
param recurrenceStartDate string

@description('Recurrence window end, ISO 8601 datetime. Cost Management exports stop firing after this date')
param recurrenceEndDate string

// Scoped to the resource group the module is deployed into.
resource costExport 'Microsoft.CostManagement/exports@2023-11-01' = {
  name: exportName
  scope: resourceGroup()
  properties: {
    schedule: {
      status: 'Active'
      recurrence: 'Daily'
      recurrencePeriod: {
        from: recurrenceStartDate
        to: recurrenceEndDate
      }
    }
    format: 'Csv'
    deliveryInfo: {
      destination: {
        resourceId: storageAccountId
        container: containerName
        rootFolderPath: 'exports'
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
