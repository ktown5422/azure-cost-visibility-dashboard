@description('Name of the action group')
param actionGroupName string

@description('Email address that receives budget alert notifications')
param notificationEmail string

@description('Short name shown in SMS/push notifications (max 12 characters)')
param shortName string = 'CostAlert'

resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: actionGroupName
  location: 'global'
  properties: {
    groupShortName: shortName
    enabled: true
    emailReceivers: [
      {
        name: 'CostOwnerEmail'
        emailAddress: notificationEmail
        useCommonAlertSchema: true
      }
    ]
  }
}

output actionGroupId string = actionGroup.id
