// Resource-group-scoped: one notification target reused by the budget
// (and, in a real environment, by other Azure Monitor alerts too).
@description('Email address to notify.')
param alertEmail string

@description('Name of the action group resource.')
param actionGroupName string = 'ag-cost-visibility-lab'

resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: actionGroupName
  location: 'global'
  properties: {
    groupShortName: 'costvislab'
    enabled: true
    emailReceivers: [
      {
        name: 'primary-email'
        emailAddress: alertEmail
        useCommonAlertSchema: true
      }
    ]
  }
}

output actionGroupId string = actionGroup.id
