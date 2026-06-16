# Setup Steps

Step-by-step path to deploy this project against a real Azure subscription. Follow in order; check off each as you complete it and capture a screenshot (see `screenshots/`).

## 1. Prerequisites

- An Azure subscription with Owner or Contributor + User Access Administrator rights (budgets and action groups need write access at the resource group scope).
- Azure CLI (`az`) installed and logged in: `az login`.
- Bicep CLI available (`az bicep install` if `az bicep version` fails).

## 2. Create the resource group

```bash
az group create --name rg-cost-visibility-lab --location eastus
```

This matches the resource group shown in `screenshots/01-resource-group-created.jpeg`.

## 3. Deploy the infrastructure

```bash
./scripts/deploy.sh rg-cost-visibility-lab you@example.com 50
```

This deploys, via `infra/main.bicep`:
- An **action group** (`ag-cost-visibility`) that emails you on alert.
- A **budget** (`budget-cost-visibility`) at 50/80% actual spend and 100% forecasted spend, wired to the action group.
- A **storage account** with a `cost-exports` container.
- A **Cost Management export** that lands a daily CSV of month-to-date actual cost into that container.

Confirm in the portal: Resource Group > budget-cost-visibility (under Cost Management), and Cost Management > Exports.

## 4. Validate the budget alert path

Budgets only evaluate once every ~8 hours and notifications can take up to 24 hours after a threshold is crossed - don't expect an instant email. To sanity check the wiring without waiting on real spend, send a test notification from the action group itself: Action group > Test action group > select the email receiver.

## 5. Run the governance queries

```bash
az graph query -q "$(cat queries/untagged-resources.kql)"
az graph query -q "$(cat queries/orphaned-managed-disks.kql)"
az graph query -q "$(cat queries/unassociated-public-ips.kql)"
```

These work across your existing resources immediately - no need to wait for cost data to accumulate.

## 6. Import the workbook

In the portal: Monitor > Workbooks > New > Advanced Editor (the `</>` icon), paste the contents of `workbooks/cost-visibility-workbook.json`, Apply, then Done Editing, then save it into `rg-cost-visibility-lab`. Pick your subscription in the parameter pill at the top and confirm all three tables render. This file wasn't deployed against a live tenant while authoring it - if a panel doesn't render, the workbook's own editor UI will point at the broken item; fix it there and copy the corrected JSON back into this repo.

## 7. Review cost exports

After ~24 hours, check the `cost-exports` container in the deployed storage account for the first CSV. Open it in Excel or load it into Power BI for trend charts - see `docs/dashboard-design.md` for why trend visualization is left to Cost Analysis / Excel rather than rebuilt in the workbook.

## 8. Write it up

Once you've gone through steps 1-7 once for real, fill in `docs/lessons-learned.md` and use `reports/` to produce your first cost visibility report.
