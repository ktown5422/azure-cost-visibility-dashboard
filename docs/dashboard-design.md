# Dashboard Design

## Two audiences, two tools

Cost visibility work splits into two different questions, and this project deliberately uses a different tool for each rather than forcing one dashboard to do both:

1. **"How much are we spending, and on what trend?"** - this is exactly what Azure Cost Management's built-in **Cost Analysis** view does, backed by the daily CSV exports this project sets up (`infra/modules/costExport.bicep`). It already has grouping, filtering, forecasting, and the ability to pin views to an Azure Portal dashboard. Rebuilding that as a custom chart is low-value duplication.
2. **"Where is money being wasted, and is anything untagged or ownerless?"** - Cost Analysis doesn't answer this well; you need to query the resource fleet itself. That's what `workbooks/cost-visibility-workbook.json` is for, backed by Azure Resource Graph (`queries/*.kql`).

Splitting it this way means each half is built on the tool that's actually good at it, instead of a single workbook fighting both the Cost Management Query API and Resource Graph.

## Why Resource Graph for the workbook

The workbook uses `queryType: 1` / `resourceType: microsoft.resourcegraph/resources` items, which query the live resource fleet across subscriptions with no ingestion delay. Three signals are included to start:

| Query | What it catches | Why it matters for cost |
|---|---|---|
| `untagged-resources.kql` | Resources missing `CostCenter` or `Environment` tags | Untaggable spend can't be charged back to a team, which is usually why "nobody owns this bill" |
| `orphaned-managed-disks.kql` | Managed disks not attached to any VM | Billed in full, delivering zero value |
| `unassociated-public-ips.kql` | Public IPs with no IP configuration | Standard SKU IPs bill hourly idle |

These are intentionally the highest-signal, lowest-noise waste indicators - the ones that show up in nearly every FinOps audit. Good next additions once this is running for real: stopped-but-not-deallocated VMs (needs `--expand properties.extended.instanceView` on the Resource Graph call), unattached NICs, and empty App Service plans.

## Why a Subscription parameter

The workbook opens with a `type: 9` parameter item (a Subscription picker, parameter `type: 6`) so the same workbook can be pointed at any subscription you have access to, rather than hardcoding a subscription ID into every query.

## What's deliberately out of scope (for now)

- **Multi-tenant / Cost Management Query API charts** (cost-by-service donut, spend trend line) were considered but dropped from the workbook. That API's exact request/response shape inside a Workbook's ARM-data-source item couldn't be verified against live documentation in this session, and shipping unverified JSON for the centerpiece chart would be worse than not shipping it. Use Cost Analysis or load the CSV export into Power BI/Excel for that view instead (see `docs/setup-steps.md` step 7). Once you've deployed this for real, capture the working JSON from the portal's own editor and fold it back into this file.
- **Automated remediation** (deleting orphaned disks, deallocating idle VMs) is intentionally not automated here. A waste-detection dashboard should drive a human decision before anything destructive happens.
