# Azure Cost Visibility Dashboard

## Business Problem
Business owners often cannot read, predict, or explain their Azure cloud bill until costs have already increased. This project solves that problem by creating cost visibility, budget alerts, tagging governance, and an investigation workflow.

## Solution
Built an Azure Cost Visibility Dashboard using Azure Cost Management, Budgets, Azure Monitor, Action Groups, Logic Apps, Azure Workbooks, Log Analytics Workspace, Azure Resource Graph, Storage Accounts, and resource tags.

## Azure Services Used
- Azure Cost Management
- Azure Budgets
- Azure Monitor
- Azure Action Groups
- Azure Logic Apps
- Azure Workbooks
- Log Analytics Workspace
- Azure Resource Graph
- Azure Storage Account
- Resource Tags

## Architecture
Budget threshold reached  
→ Azure Monitor Action Group  
→ Logic App email notification  
→ Cloud engineer reviews Workbook and Cost Analysis  
→ Optimization recommendations documented

## What I Built
- Created a dedicated resource group: `rg-cost-visibility-lab`
- Deployed a storage account: `stcostvislabkevin001`
- Applied governance tags for project, owner, department, environment, and cost center
- Created budget thresholds for 50%, 80%, 90% forecasted, and 100%
- Built a Logic App email workflow for alert notifications
- Created an Azure Monitor Action Group
- Created a Log Analytics Workspace
- Built an Azure Workbook dashboard
- Used Azure Resource Graph queries to inventory tagged resources
- Documented a cost investigation workflow

## Business Outcome
This lab helps organizations detect cloud cost overruns early, explain spending by resource group or service, improve ownership through tagging, and notify stakeholders before cloud spending becomes a business problem.