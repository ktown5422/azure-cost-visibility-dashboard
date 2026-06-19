# Troubleshooting Log

## Purpose

This document records issues encountered while building the Azure Cost Visibility Dashboard and how each issue was resolved.

---

## Issue 1: Azure VM Quota Limitation

### Problem

Virtual machine deployment failed because the Azure for Students subscription did not have quota available for the selected VM family.

### Resolution

Removed the VM dependency from the project and used a Storage Account as the primary billable Azure resource.

### Lesson Learned

Cloud engineers must understand subscription limitations and regional service availability.

---

## Issue 2: VM Sizes Unavailable

### Problem

Several VM sizes were unavailable in the selected region.

### Resolution

Reviewed supported regions and alternative resource types before redesigning the lab architecture.

### Lesson Learned

Resource planning should include validation of regional service availability.

---

## Issue 3: Workbook Required Log Analytics Workspace

### Problem

Azure Workbook displayed:

"No Log Analytics workspace resources are selected."

### Resolution

Created:

law-cost-visibility

and selected the workspace within Workbook configuration.

### Lesson Learned

Azure Workbooks support multiple data sources and require proper configuration.

---

## Issue 4: Azure Resource Graph Parser Error

### Problem

Azure Resource Graph returned a parser failure error.

### Resolution

Updated the query syntax and used the correct Resource Graph schema.

Working query:

Resources
| where resourceGroup =~ "rg-cost-visibility-lab"
| project name, type, location, resourceGroup

### Lesson Learned

Azure Resource Graph and Log Analytics use different query models and available tables.

---

## Issue 5: Cost Data Delay

### Problem

Newly created resources did not immediately appear in Cost Analysis.

### Resolution

Allowed Azure Cost Management additional time to refresh billing data.

### Lesson Learned

Cloud billing systems do not always provide real-time reporting.

---

## Summary

This project provided hands-on experience with:

- Azure Cost Management
- Azure Monitor
- Azure Logic Apps
- Azure Workbooks
- Azure Resource Graph
- Governance tagging
- Operational troubleshooting
- Technical documentation