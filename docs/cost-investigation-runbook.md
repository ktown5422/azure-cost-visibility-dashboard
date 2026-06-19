# Azure Cost Investigation Runbook

## Purpose

This runbook provides a repeatable process for investigating unexpected Azure cost increases and identifying optimization opportunities.

---

## Trigger Conditions

Use this runbook when:

- A budget alert is triggered
- Monthly spend exceeds expectations
- Forecasted spend exceeds budget
- A stakeholder requests an explanation for increased cloud spending

---

## Environment Information

| Resource | Name |
|-----------|-----------|
| Resource Group | rg-cost-visibility-lab |
| Storage Account | stcostvislabkevin001 |
| Logic App | la-cost-alert-email |
| Action Group | ag-cost-visibility-alerts |
| Log Analytics Workspace | law-cost-visibility |
| Workbook | wb-cost-visibility-dashboard |

---

## Investigation Process

### Step 1: Review Alert

Review the budget alert email and document:

- Alert threshold reached
- Date and time
- Current spend amount
- Forecasted spend amount

---

### Step 2: Open Cost Analysis

Navigate to:

Azure Portal → Cost Management + Billing → Cost Analysis

Review costs by:

- Resource
- Service Name
- Resource Group
- Tag

---

### Step 3: Identify Cost Drivers

Determine which resources generated the highest costs.

Common cost drivers:

- Virtual Machines
- Storage Accounts
- Databases
- Monitoring Services
- Networking Services

---

### Step 4: Validate Resource Ownership

Open the Workbook Dashboard.

Review:

- Resource Inventory
- Tagged Resources

Confirm ownership using:

- Project
- Environment
- Owner
- Department
- CostCenter

---

### Step 5: Investigate Recent Changes

Review:

- Newly deployed resources
- Configuration changes
- Unexpected resource growth
- Untagged resources

---

### Step 6: Recommend Optimization Actions

Examples:

- Delete unused resources
- Resize overprovisioned resources
- Move storage to Cool or Archive tier
- Implement lifecycle management
- Improve tagging compliance

---

### Step 7: Document Findings

Record:

- Root cause
- Cost impact
- Recommended actions
- Business impact

---

## Escalation Criteria

Escalate if:

- Costs exceed 100% of budget
- Ownership cannot be identified
- Production systems are affected
- Resource usage cannot be explained

---

## Business Outcome

This process improves visibility into Azure spending and helps organizations identify and address unexpected cloud costs before they become business problems.