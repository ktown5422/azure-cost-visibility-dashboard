# Azure Cost Visibility Dashboard Lab Guide

## Overview

This lab walks through building an Azure Cost Visibility Dashboard that helps business owners and cloud teams monitor cloud spending, receive budget alerts, organize resources with tags, and investigate unexpected cost increases.

## Business Problem

Business owners often cannot read, predict, or explain their Azure cloud bill until costs have already increased. Without budget alerts, tagging, and dashboards, teams may not know who owns resources, which services are driving costs, or when spending is trending above budget.

## Solution

This lab uses Azure Cost Management, Budgets, Azure Monitor, Action Groups, Logic Apps, Workbooks, Log Analytics Workspace, Azure Resource Graph, Storage Accounts, and resource tags to create a cost visibility workflow.

---

# Prerequisites

- Azure subscription
- Azure Portal access
- Basic understanding of cloud resources
- Email account for alert testing

---

# Phase 1: Create Resource Group

## Steps

1. Go to the Azure Portal.
2. Search for **Resource groups**.
3. Click **Create**.
4. Enter the following:

| Setting | Value |
|---|---|
| Resource group name | `rg-cost-visibility-lab` |
| Region | `South Central US` |

5. Click **Review + create**.
6. Click **Create**.

## Why this matters

A resource group keeps all lab resources organized in one place. It also makes cost tracking and cleanup easier.

## Screenshot to capture

- Resource group overview

---

# Phase 2: Add Governance Tags

## Steps

1. Open `rg-cost-visibility-lab`.
2. Go to **Tags**.
3. Add the following tags:

| Name | Value |
|---|---|
| Project | `CostVisibilityDashboard` |
| Environment | `Lab` |
| Owner | `Kevin` |
| Department | `CloudOps` |
| CostCenter | `Training` |

4. Click **Apply**.

## Why this matters

Tags help cloud teams track ownership, environment, project, department, and cost center. This is important for cloud governance and cost reporting.

## Screenshot to capture

- Resource group tags

---

# Phase 3: Create Storage Account

## Steps

1. Search for **Storage accounts**.
2. Click **Create**.
3. Enter the following:

| Setting | Value |
|---|---|
| Resource group | `rg-cost-visibility-lab` |
| Storage account name | `stcostvislabkevin001` |
| Region | `South Central US` |
| Performance | `Standard` |
| Redundancy | `Locally-redundant storage (LRS)` |

4. Click **Review + create**.
5. Click **Create**.

## Recommended security settings

| Setting | Value |
|---|---|
| Require secure transfer | Enabled |
| Allow blob anonymous access | Disabled |
| Minimum TLS version | 1.2 |
| Access tier | Hot |

## Why this matters

A storage account is a low-cost Azure resource that can generate cost data for the dashboard.

## Screenshot to capture

- Storage account overview

---

# Phase 4: Add Tags to Storage Account

## Steps

1. Open `stcostvislabkevin001`.
2. Go to **Tags**.
3. Add the same governance tags:

| Name | Value |
|---|---|
| Project | `CostVisibilityDashboard` |
| Environment | `Lab` |
| Owner | `Kevin` |
| Department | `CloudOps` |
| CostCenter | `Training` |

4. Click **Apply**.

## Screenshot to capture

- Storage account tags

---

# Phase 5: Create Blob Container and Upload Test File

## Steps

1. Open the storage account.
2. Go to **Containers**.
3. Click **+ Container**.
4. Enter:

| Setting | Value |
|---|---|
| Name | `cost-reports` |
| Public access level | `Private` |

5. Click **Create**.

## Upload sample file

Create a local file named:

```text
sample-cost-report.txt
```

Add this content:

```text
Azure Cost Visibility Dashboard
Test file for storage cost tracking.
Project: CostVisibilityDashboard
Environment: Lab
```

Upload the file into the `cost-reports` container.

## Screenshot to capture

- Blob container with uploaded file

---

# Phase 6: Create Azure Budget

## Steps

1. Search for **Cost Management + Billing**.
2. Go to **Cost Management**.
3. Select the Azure subscription.
4. Go to **Budgets**.
5. Click **Add**.
6. Enter:

| Setting | Value |
|---|---|
| Budget name | `budget-cost-visibility-lab` |
| Reset period | Monthly |
| Budget amount | `$5` |

7. Add alert thresholds:

| Threshold | Type |
|---|---|
| 50% | Actual |
| 80% | Actual |
| 90% | Forecasted |
| 100% | Actual |

8. Add email recipient.
9. Click **Create**.

## Why this matters

Budgets help notify cloud teams before spending gets too high. Budgets do not automatically stop resources; they send alerts.

## Screenshot to capture

- Budget configuration and thresholds

---

# Phase 7: Create Logic App Email Workflow

## Steps

1. Search for **Logic Apps**.
2. Click **Create**.
3. Enter:

| Setting | Value |
|---|---|
| Resource group | `rg-cost-visibility-lab` |
| Logic App name | `la-cost-alert-email` |
| Region | `South Central US` |
| Plan type | Consumption |

4. Click **Review + create**.
5. Click **Create**.

## Build workflow

1. Open the Logic App.
2. Go to **Logic app designer**.
3. Choose **Blank workflow**.
4. Add trigger:

```text
When an HTTP request is received
```

5. Paste this JSON schema:

```json
{
  "type": "object",
  "properties": {
    "alertType": {
      "type": "string"
    },
    "resourceGroup": {
      "type": "string"
    },
    "threshold": {
      "type": "string"
    },
    "message": {
      "type": "string"
    }
  }
}
```

6. Add an email action using Gmail, Outlook, or Office 365 Outlook.
7. Use this subject:

```text
Azure Cost Alert - Cost Visibility Lab
```

8. Use this body:

```text
Azure Cost Alert Notification

Alert Type: alertType
Resource Group: resourceGroup
Threshold: threshold
Message: message

Recommended Action:
1. Open Azure Cost Management.
2. Review cost by resource group.
3. Review cost by service.
4. Check for untagged or unexpected resources.
5. Delete or resize unused resources.
```

9. Save the Logic App.

## Test payload

Use this JSON body to test the workflow:

```json
{
  "alertType": "Budget Alert",
  "resourceGroup": "rg-cost-visibility-lab",
  "threshold": "80%",
  "message": "Monthly Azure spend has reached 80% of the lab budget."
}
```

## Screenshot to capture

- Logic App workflow
- Successful run history
- Email notification received

---

# Phase 8: Create Azure Monitor Action Group

## Steps

1. Search for **Monitor**.
2. Go to **Alerts**.
3. Select **Action groups**.
4. Click **Create**.
5. Enter:

| Setting | Value |
|---|---|
| Resource group | `rg-cost-visibility-lab` |
| Region | Global |
| Action group name | `ag-cost-visibility-alerts` |
| Display name | `CostAlert` |

6. Add notification type:

```text
Email/SMS message/Push/Voice
```

7. Add email recipient.
8. Add action type:

```text
Logic App
```

9. Select:

```text
la-cost-alert-email
```

10. Click **Review + create**.
11. Click **Create**.

## Why this matters

Action Groups define who or what gets notified when an alert fires. In production, this may notify engineers, managers, finance teams, or automation workflows.

## Screenshot to capture

- Action Group overview
- Email notification setup
- Logic App action setup

---

# Phase 9: Create Log Analytics Workspace

## Steps

1. Search for **Log Analytics workspaces**.
2. Click **Create**.
3. Enter:

| Setting | Value |
|---|---|
| Resource group | `rg-cost-visibility-lab` |
| Name | `law-cost-visibility` |
| Region | `South Central US` |

4. Click **Review + create**.
5. Click **Create**.

## Why this matters

Log Analytics stores monitoring and log data. This lab mainly uses Azure Resource Graph for inventory, but Log Analytics creates a stronger foundation for future monitoring labs.

## Screenshot to capture

- Log Analytics Workspace overview

---

# Phase 10: Create Azure Workbook Dashboard

## Steps

1. Search for **Monitor**.
2. Go to **Workbooks**.
3. Click **New**.
4. Add a text section:

```markdown
# Azure Cost Visibility Dashboard

## Business Problem
Business owners often cannot read, predict, or explain their Azure cloud bill until costs have already increased.

## Solution
This dashboard provides visibility into Azure resources, ownership, budget controls, cost alerts, and investigation procedures.
```

## Add Resource Inventory query

1. Click **Add**.
2. Select **Add query**.
3. Set data source to:

```text
Azure Resource Graph
```

4. Paste this query:

```kusto
Resources
| where resourceGroup =~ "rg-cost-visibility-lab"
| project name, type, location, resourceGroup
```

5. Set visualization to **Grid**.
6. Name the section:

```text
Resource Inventory
```

## Add Tagged Resources query

Add another Azure Resource Graph query:

```kusto
Resources
| where resourceGroup =~ "rg-cost-visibility-lab"
| project name,
          type,
          location,
          Project=tostring(tags["Project"]),
          Environment=tostring(tags["Environment"]),
          Owner=tostring(tags["Owner"]),
          Department=tostring(tags["Department"]),
          CostCenter=tostring(tags["CostCenter"])
```

Set visualization to **Grid**.

Name the section:

```text
Tagged Resources
```

## Add Budget Configuration section

Add a text block:

```markdown
## Budget Configuration

Monthly Budget: $5

Alert Thresholds:

- 50% Actual Spend
- 80% Actual Spend
- 90% Forecasted Spend
- 100% Actual Spend

Notification Method:

Azure Monitor
→ Action Group
→ Logic App
→ Email Notification
```

## Add Alert Workflow section

Add a text block:

```markdown
## Cost Alert Workflow

Budget Threshold Reached

↓

Azure Budget Alert

↓

Azure Monitor Action Group

↓

Logic App Email Notification

↓

Cloud Engineer / Business Owner
```

## Add Cost Investigation Runbook section

Add a text block:

```markdown
## Cost Investigation Runbook

When Azure costs increase unexpectedly:

1. Open Cost Analysis
2. Group by Resource Group
3. Group by Service Name
4. Review newly deployed resources
5. Review tagging compliance
6. Verify budget alerts fired
7. Recommend cleanup or optimization actions

Business Goal:
Identify and explain cost spikes before they impact the business.
```

## Save workbook

Save as:

```text
wb-cost-visibility-dashboard
```

Use:

| Setting | Value |
|---|---|
| Resource group | `rg-cost-visibility-lab` |
| Region | `South Central US` |

## Screenshot to capture

- Workbook dashboard
- Resource Inventory query
- Tagged Resources query
- Cost Alert Workflow section

---

# Phase 11: Review Cost Analysis

## Steps

1. Search for **Cost Management + Billing**.
2. Go to **Cost Management**.
3. Open **Cost Analysis**.
4. Review cost by:

```text
Resource
Service name
Resource group
Tag
```

## What to look for

- Storage account cost
- Cost by resource group
- Cost by service
- Cost by tag
- Forecasted spending

## Screenshot to capture

- Cost Analysis grouped by resource or service

---

# Phase 12: Document Cost Investigation Report

Create:

```text
reports/cost-analysis-report.md
```

Include:

```markdown
# Azure Cost Analysis Report

## Investigation Date
[Insert date]

## Resource Group
rg-cost-visibility-lab

## Resources Reviewed
- stcostvislabkevin001
- la-cost-alert-email
- ag-cost-visibility-alerts
- law-cost-visibility

## Findings
The lab resources are organized under a dedicated resource group and tagged for ownership, project, department, environment, and cost center. Budget alerts were configured to notify stakeholders when spending reaches defined thresholds.

## Recommendations
- Continue monitoring monthly cost trends
- Maintain tagging standards
- Review budget alerts monthly
- Delete unused resources
- Apply lifecycle policies for storage data

## Business Impact
This process improves cost visibility, reduces surprise cloud bills, and gives stakeholders a clear way to investigate and explain Azure spending.
```

---

# Phase 13: Document Troubleshooting

Create:

```text
docs/troubleshooting-log.md
```

Include issues encountered during the lab:

```markdown
# Troubleshooting Log

## Issue 1: VM quota limits
Azure for Students subscription did not allow selected VM sizes in certain regions.

## Resolution
Used a Storage Account instead of a VM to create a low-cost billable resource.

## Issue 2: Workbook required Log Analytics Workspace
Workbook query showed: "No Log Analytics workspace resources are selected."

## Resolution
Created `law-cost-visibility` and learned the difference between Log Analytics and Azure Resource Graph data sources.

## Issue 3: Azure Resource Graph parser error
Initial query failed due to syntax.

## Resolution
Used the correct table name `Resources` and correct tag syntax:

```kusto
Resources
| where resourceGroup =~ "rg-cost-visibility-lab"
| project name, type, location, resourceGroup
```

For tags:

```kusto
Resources
| where resourceGroup =~ "rg-cost-visibility-lab"
| project name,
          type,
          location,
          Project=tostring(tags["Project"]),
          Environment=tostring(tags["Environment"]),
          Owner=tostring(tags["Owner"]),
          Department=tostring(tags["Department"]),
          CostCenter=tostring(tags["CostCenter"])
```
```

---

# Phase 14: Cleanup

To avoid unnecessary charges:

1. Go to **Resource groups**.
2. Open:

```text
rg-cost-visibility-lab
```

3. Review all resources.
4. Delete individual resources or delete the entire resource group when the lab is complete.

## Important

Only delete the resource group after taking all screenshots and documenting the project.

---

# Final Validation Checklist

- [ ] Resource group created
- [ ] Tags applied
- [ ] Storage account created
- [ ] Blob container created
- [ ] Sample file uploaded
- [ ] Budget created
- [ ] Budget thresholds configured
- [ ] Logic App workflow created
- [ ] Email alert tested
- [ ] Action Group created
- [ ] Log Analytics Workspace created
- [ ] Workbook dashboard created
- [ ] Azure Resource Graph queries working
- [ ] Cost Analysis reviewed
- [ ] Screenshots added to GitHub
- [ ] Cost investigation report written
- [ ] Troubleshooting log written
- [ ] README updated
- [ ] Architecture diagram added

---

# Business Outcome

This lab demonstrates how a cloud engineer can help a business monitor cloud costs, organize resource ownership, automate budget alerts, and investigate unexpected spending before it becomes a financial problem.