// Resource-group-scoped budget mirroring the Module 2 portal steps:
// alerts at 80%/100% actual spend and 100% forecasted spend.
@description('Name of the budget resource.')
param budgetName string = 'budget-cost-visibility-lab'

@description('Monthly budget amount.')
param budgetAmount int

@description('Resource ID of the action group to notify.')
param actionGroupId string

@description('Budget start date, first of the current month. utcNow() defaults can only be set on a parameter, not inline.')
param startDate string = utcNow('yyyy-MM-01')

resource budget 'Microsoft.Consumption/budgets@2023-11-01' = {
  name: budgetName
  properties: {
    category: 'Cost'
    amount: budgetAmount
    timeGrain: 'Monthly'
    timePeriod: {
      startDate: startDate
    }
    notifications: {
      Actual_GreaterThan_80_Percent: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 80
        thresholdType: 'Actual'
        contactGroups: [
          actionGroupId
        ]
        contactEmails: []
        contactRoles: []
      }
      Actual_GreaterThan_100_Percent: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 100
        thresholdType: 'Actual'
        contactGroups: [
          actionGroupId
        ]
        contactEmails: []
        contactRoles: []
      }
      Forecasted_GreaterThan_100_Percent: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 100
        thresholdType: 'Forecasted'
        contactGroups: [
          actionGroupId
        ]
        contactEmails: []
        contactRoles: []
      }
    }
  }
}
