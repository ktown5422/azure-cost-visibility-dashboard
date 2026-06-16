# Azure Cost Visibility Dashboard

A self-contained FinOps lab: Bicep IaC for budgets/alerts/cost exports, Azure Resource Graph queries for waste detection, an Azure Monitor Workbook to visualize them, and the documentation/reporting templates a real cost-visibility initiative needs.

## Why this exists

Most "cost dashboard" projects just screenshot the built-in Cost Management blade. This one builds the supporting infrastructure around it: automated budget alerts, a recurring cost export pipeline, and governance queries that catch the waste Cost Analysis doesn't surface on its own (untagged, orphaned, and unassociated resources).

## Architecture

```
                 ┌─────────────────────┐
                 │  Resource Group      │
                 │  rg-cost-visibility  │
                 └──────────┬───────────┘
                            │
        ┌───────────────────┼───────────────────────┐
        │                   │                        │
        ▼                   ▼                        ▼
┌───────────────┐  ┌──────────────────┐   ┌─────────────────────┐
│ Budget          │  │ Cost Mgmt Export │   │ Resource Graph       │
│ 50/80% actual   │  │ → daily CSV      │   │ queries (untagged,   │
│ 100% forecast   │  │ → Storage acct   │   │ orphaned disks, IPs) │
└───────┬─────────┘  └─────────┬────────┘   └──────────┬──────────┘
        │                      │                        │
        ▼                      ▼                        ▼
┌───────────────┐    Excel / Power BI /        ┌───────────────────┐
│ Action Group   │    Cost Analysis             │ Azure Workbook     │
│ → email alert  │    (trend reporting)         │ (governance view)  │
└───────────────┘                               └───────────────────┘
```

See `docs/dashboard-design.md` for why trend reporting and governance reporting are deliberately split across two tools instead of one.

## Repo structure

```
infra/        Bicep IaC: budget, action group, storage account, Cost Management export
queries/      Azure Resource Graph (KQL) queries for waste/governance detection
workbooks/    Azure Monitor Workbook JSON visualizing the queries above
scripts/      deploy.sh - wraps the Bicep deployment
docs/         setup steps, design rationale, alerting strategy, lessons learned
reports/      Templates for recurring cost reports, exec summaries, stakeholder emails
screenshots/  Evidence of real deployment steps
```

## Quick start

```bash
az group create --name rg-cost-visibility-lab --location eastus
./scripts/deploy.sh rg-cost-visibility-lab you@example.com 50
```

Then follow `docs/setup-steps.md` for importing the workbook and running the governance queries.

## Status

Infrastructure, queries, and documentation are written and the resource group has been created in Azure (`screenshots/01-resource-group-created.jpeg`). The Bicep templates and workbook haven't been deployed end-to-end against a live subscription yet from this session - see `docs/setup-steps.md` step 6 for the one workbook caveat to watch for. `docs/lessons-learned.md` and `reports/` are templates to fill in after a real run.
