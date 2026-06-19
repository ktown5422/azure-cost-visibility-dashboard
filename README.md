# Azure Cost Visibility Dashboard

## Overview

The Azure Cost Visibility Dashboard is a cloud operations project designed to help organizations monitor Azure spending, receive proactive budget alerts, investigate unexpected cost increases, and improve cost accountability through governance and resource tagging.

This project demonstrates practical cloud engineering skills in Azure Cost Management, monitoring, automation, governance, operational documentation, and troubleshooting.

---

## Business Problem

Organizations often struggle to understand, predict, and control cloud spending.

Cloud costs can increase unexpectedly when resources are over-provisioned, left running, improperly tagged, or deployed without governance controls. Without visibility into budgets, forecasts, and resource ownership, stakeholders may not discover cost issues until the monthly invoice arrives.

### Example Scenario

A team expects a monthly Azure spend of $5,000.

By the end of the month, the actual spend reaches $30,000 due to:

- Unused resources remaining deployed
- Lack of budget monitoring
- Missing ownership tags
- No automated alerting
- Limited visibility into service-level costs

---

## Solution

The Azure Cost Visibility Dashboard provides proactive cost monitoring, governance, investigation, and optimization capabilities.

The solution uses:

- Azure Cost Management
- Azure Budgets
- Azure Monitor
- Azure Action Groups
- Azure Logic Apps
- Azure Workbooks
- Azure Resource Graph
- Governance Tags

### Key Capabilities

#### Cost Monitoring

- Track Azure spending trends
- Monitor actual versus forecasted costs
- Analyze costs by resource and service

#### Alerting

- Budget threshold monitoring
- Automated email notifications
- Early warning of potential cost overruns

#### Governance

- Resource ownership tracking
- Project and department tagging
- Cost center allocation

#### Investigation

- Centralized Workbook dashboard
- Resource inventory reporting
- Cost analysis workflow
- Cost investigation runbook

#### Optimization

- Identify unused resources
- Improve tagging compliance
- Recommend cost-saving actions

---

## Architecture

![Architecture Diagram](architecture/architecture-diagram.png)

Additional Architecture Documentation:

- [Architecture Explanation](architecture/architecture-explanation.md)

---

## Azure Services Used

| Service | Purpose |
|----------|----------|
| Azure Cost Management | Monitor Azure spending |
| Azure Budgets | Define spending thresholds |
| Azure Monitor | Generate alerts |
| Azure Action Groups | Route notifications |
| Azure Logic Apps | Automate email alerts |
| Azure Workbooks | Cost visibility dashboard |
| Azure Resource Graph | Resource inventory and governance |
| Log Analytics Workspace | Monitoring foundation |
| Azure Storage Account | Generate cost data and resource activity |
| Resource Tags | Ownership and cost allocation |

---

## Project Structure

```text
azure-cost-visibility-dashboard/
│
├── README.md
│
├── architecture/
│   ├── architecture-diagram.png
│   ├── architecture-diagram.drawio
│   └── architecture-explanation.md
│
├── docs/
│   ├── problem-solution.md
│   ├── lab-guide.md
│   ├── cost-investigation-runbook.md
│   ├── troubleshooting-log.md
│   └── lessons-learned.md
│
└── screenshots/
```

---

## Documentation

### Problem and Solution

Explains the business problem, root causes, solution design, and business value.

Location:

```text
docs/problem-solution.md
```

### Lab Guide

Step-by-step implementation guide for rebuilding the project.

Location:

```text
docs/lab-guide.md
```

### Cost Investigation Runbook

Operational process used when a budget alert is triggered.

Location:

```text
docs/cost-investigation-runbook.md
```

### Troubleshooting Log

Issues encountered and resolutions documented during implementation.

Location:

```text
docs/troubleshooting-log.md
```

### Lessons Learned

Technical, operational, and business lessons learned while building the project.

Location:

```text
docs/lessons-learned.md
```

---

## Screenshots

### Resource Group

![Resource Group](screenshots/01-resource-group.png)

### Budget Alerts

![Budget Alerts](screenshots/04-budget-alerts.png)

### Logic App Workflow

![Logic App Workflow](screenshots/05-logic-app-workflow.png)

### Workbook Dashboard

![Workbook Dashboard](screenshots/08-workbook-dashboard.png)

### Email Notification

![Email Alert](screenshots/10-email-alert.png)

---

## Skills Demonstrated

### Cloud Engineering

- Azure Cost Management
- Azure Governance
- Cloud Operations
- Monitoring and Alerting
- Resource Management

### Automation

- Azure Logic Apps
- Action Groups
- Event-Driven Workflows

### Observability

- Azure Monitor
- Azure Workbooks
- Azure Resource Graph

### Documentation

- Architecture Design
- Runbooks
- Troubleshooting Guides
- Operational Documentation

---

## Business Outcome

This solution helps organizations:

- Detect cloud cost overruns earlier
- Improve visibility into Azure spending
- Identify resource ownership
- Increase accountability
- Reduce cloud waste
- Establish repeatable investigation procedures

By combining monitoring, automation, governance, and documentation, the Azure Cost Visibility Dashboard provides a practical example of how cloud engineers help organizations understand, control, and optimize cloud spending.