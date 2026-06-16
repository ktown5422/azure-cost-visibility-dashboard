# Cost Visibility Report

**Period:** [e.g., June 2026]
**Scope:** [subscription(s) / resource group(s) covered]
**Prepared by:** [name]
**Source data:** Cost Management export (`cost-exports` container) + `workbooks/cost-visibility-workbook.json`

## 1. Spend summary

| Metric | Value |
|---|---|
| Budget | $[amount] |
| Actual spend (month to date) | $[amount] |
| % of budget consumed | [%] |
| Forecasted spend (month end) | $[amount] |
| Variance vs. last month | [+/- %] |

## 2. Top cost drivers

| Service / Resource | Spend | % of total | Trend vs. last month |
|---|---|---|---|
| [service] | $[amount] | [%] | [up/down/flat] |
| [service] | $[amount] | [%] | [up/down/flat] |
| [service] | $[amount] | [%] | [up/down/flat] |

## 3. Governance findings (from Resource Graph queries)

### Untagged resources
[Count] resources missing `CostCenter` or `Environment` tags. [List or summarize the worst offenders.]

### Orphaned managed disks
[Count] unattached disks, totaling [size] GB, estimated $[amount]/month in avoidable spend.

### Unassociated public IPs
[Count] public IPs with no attached configuration, estimated $[amount]/month in avoidable spend.

## 4. Budget alert activity

[Did any of the 50%/80%/forecasted-100% notifications fire this period? When, and what was the response?]

## 5. Recommendations

1. [Recommendation, owner, target date]
2. [Recommendation, owner, target date]
3. [Recommendation, owner, target date]

## 6. Appendix

[Links to raw export CSVs, workbook screenshots, or supporting queries used.]
