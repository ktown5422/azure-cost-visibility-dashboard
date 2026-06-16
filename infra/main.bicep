targetScope = 'resourceGroup'

@description('Email address that receives budget alert notifications')
param notificationEmail string

@description('Monthly budget amount in your subscription billing currency')
param budgetAmount int = 50

@description('Azure region for the storage account that receives cost exports')
param location string = resourceGroup().location

@description('Used to derive the budget start date and the export recurrence window. Do not override unless re-running this template to extend an expiring budget/export')
param deploymentTimestamp string = utcNow('yyyy-MM-ddT00:00:00Z')

var actionGroupName = 'ag-cost-visibility'
var budgetName = 'budget-cost-visibility'
var exportName = 'export-cost-visibility'
var storageAccountName = toLower('stcostvis${uniqueString(resourceGroup().id)}')

var budgetStartDate = '${take(deploymentTimestamp, 7)}-01'
var budgetEndDate = dateTimeAdd(budgetStartDate, 'P2Y', 'yyyy-MM-dd')
var exportEndDate = dateTimeAdd(deploymentTimestamp, 'P5Y')

module actionGroup 'modules/actionGroup.bicep' = {
  name: 'deploy-action-group'
  params: {
    actionGroupName: actionGroupName
    notificationEmail: notificationEmail
  }
}

module budget 'modules/budget.bicep' = {
  name: 'deploy-budget'
  params: {
    budgetName: budgetName
    amount: budgetAmount
    actionGroupId: actionGroup.outputs.actionGroupId
    startDate: budgetStartDate
    endDate: budgetEndDate
  }
}

module storage 'modules/storageAccount.bicep' = {
  name: 'deploy-storage'
  params: {
    storageAccountName: storageAccountName
    location: location
  }
}

module costExport 'modules/costExport.bicep' = {
  name: 'deploy-cost-export'
  params: {
    exportName: exportName
    storageAccountId: storage.outputs.storageAccountId
    recurrenceStartDate: deploymentTimestamp
    recurrenceEndDate: exportEndDate
  }
}

output actionGroupId string = actionGroup.outputs.actionGroupId
output storageAccountName string = storage.outputs.storageAccountName
output budgetEndDate string = budgetEndDate
