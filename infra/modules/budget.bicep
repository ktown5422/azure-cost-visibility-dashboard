@description('Name of the budget')
param budgetName string

@description('Monthly budget amount in the subscription billing currency')
param amount int

@description('Resource ID of the action group to notify on threshold breach')
param actionGroupId string

@description('First day of the month the budget tracking starts, format yyyy-MM-dd')
param startDate string

@description('Last day the budget is valid, format yyyy-MM-dd. Azure requires an end date; extend/redeploy before it lapses')
param endDate string

resource budget 'Microsoft.Consumption/budgets@2024-08-01' = {
  name: budgetName
  properties: {
    category: 'Cost'
    amount: amount
    timeGrain: 'Monthly'
    timePeriod: {
      startDate: startDate
      endDate: endDate
    }
    notifications: {
      Actual_GreaterThan_50_Percent: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 50
        thresholdType: 'Actual'
        contactEmails: []
        contactGroups: [
          actionGroupId
        ]
      }
      Actual_GreaterThan_80_Percent: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 80
        thresholdType: 'Actual'
        contactEmails: []
        contactGroups: [
          actionGroupId
        ]
      }
      Forecasted_GreaterThan_100_Percent: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 100
        thresholdType: 'Forecasted'
        contactEmails: []
        contactGroups: [
          actionGroupId
        ]
      }
    }
  }
}
