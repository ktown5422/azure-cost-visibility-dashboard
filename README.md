# Azure Cost Visibility Dashboard — Learning Lab

A hands-on lab for learning Azure by building a real thing: a cost
visibility solution that tracks spend, alerts on budget thresholds, and
reports on cloud costs the way a stakeholder would expect at a real job.

You'll do every step twice — once by hand in the Azure Portal (to learn
*what* the pieces are and why they matter), then again as Infrastructure-as-Code
with Bicep (to learn how to make it repeatable). By the end you'll have a
working budget + alert + cost export pipeline in your own subscription, plus
a portfolio-ready set of docs and reports.

## Learning objectives

By completing this lab you should be able to:

- Explain Azure's resource hierarchy (management group → subscription →
  resource group → resource) and why tagging matters for cost tracking.
- Create and scope a budget in Azure Cost Management, with threshold-based
  alerts routed through an Action Group.
- Export cost data on a schedule to durable storage for analysis.
- Build a simple cost dashboard from real subscription data.
- Codify all of the above in Bicep and deploy it with the Azure CLI.
- Write up the work the way you'd communicate it to a non-technical
  stakeholder (executive summary, report, email).

## Prerequisites

- An active Azure subscription with Owner or Contributor + User Access
  Administrator rights (needed to create action groups and budgets).
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) installed
  (`az --version` to confirm), or use [Azure Cloud Shell](https://shell.azure.com/)
  in the portal — no local install needed.
- Bicep tooling (`az bicep install` — the Azure CLI will prompt to install it
  automatically the first time you run a Bicep command if it's missing).

## Repo structure

| Path | Purpose |
|---|---|
| `docs/setup-steps.md` | The lab itself — numbered modules, portal steps and Bicep steps. **Start here.** |
| `docs/dashboard-design.md` | Design notes for the cost dashboard (filled in during Module 4). |
| `docs/alerting-strategy.md` | Budget threshold and notification strategy (filled in during Module 2). |
| `docs/lessons-learned.md` | Your running journal — what tripped you up, what you'd do differently. |
| `infra/` | Bicep templates that codify Modules 1–3. |
| `screenshots/` | Evidence captured at each portal step, numbered in order. |
| `reports/` | Capstone deliverables, written as if for a real stakeholder. |

## Quick start

```bash
az login
az account set --subscription "<your-subscription-name-or-id>"
```

Then open `docs/setup-steps.md` and start at Module 0.

## Cleanup

Azure resources cost money while they exist. Module 6 in the lab guide
covers teardown — don't skip it when you're done for the day:

```bash
az group delete --name <your-resource-group-name> --yes --no-wait
```
