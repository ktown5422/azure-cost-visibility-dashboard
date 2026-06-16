# Lab Guide: Azure Cost Visibility Dashboard

Work through the modules in order. Each one has a **Concepts** section (the
"why"), **Steps** (the "how", in the Portal), a **Validate** checklist, and
a **Capture** note telling you what screenshot to save. Bicep equivalents
for the portal-built infrastructure live in Module 5 — do the portal
version first so the IaC actually makes sense to you.

Save screenshots to `screenshots/`, numbered in sequence (e.g.
`02-budget-created.jpeg`). `01-resource-group-created.jpeg` already exists
from Module 1.

---

## Module 0: Concepts Primer

Before touching the portal, know these terms — you'll use all of them:

- **Management group / Subscription / Resource group / Resource** — Azure's
  containment hierarchy. A subscription is a billing boundary. A resource
  group (RG) is a deployment/lifecycle boundary — everything in it is
  typically created and deleted together. This lab lives in one RG.
- **Tags** — key/value pairs on resources (e.g. `project=cost-visibility-lab`,
  `env=lab`). Cost Management can group and filter by tag, which is how
  real organizations attribute shared-subscription spend to teams.
- **Cost Management + Billing** — the portal blade where you analyze spend,
  set budgets, and configure exports. Free to use; it doesn't cost extra to
  query it.
- **Budget** — a spending threshold scoped to a subscription or resource
  group, evaluated monthly/quarterly/annually, that can fire **alerts**
  (notifications) when actual or *forecasted* spend crosses a percentage
  threshold. A budget does **not** stop spending or block resource
  creation — it only notifies.
- **Action Group** — a reusable notification target (email, SMS, webhook,
  Logic App, etc.) that budgets and Azure Monitor alerts call when they
  fire. You define it once and point multiple alerts at it.
- **Cost Management export** — a scheduled job that drops a CSV of detailed
  usage/cost data into a Storage Account, so you can analyze it outside the
  portal (Excel, Power BI, a script).

---

## Module 1: Foundation — Resource Group & Tags (Portal)

**Goal:** create the resource group everything else will live in, tagged so
you can find it in Cost Analysis later.

**Steps**

1. Portal → **Resource groups** → **Create**.
2. Subscription: your subscription. Resource group name:
   `rg-cost-visibility-lab`. Region: pick the one closest to you.
3. On the **Tags** tab add:
   - `project` = `cost-visibility-lab`
   - `env` = `lab`
4. Review + create.

**Validate**
- [ ] Resource group exists and shows the two tags on its Overview blade.

**Capture:** *(already done — `screenshots/01-resource-group-created.jpeg`)*

---

## Module 2: Budgets & Cost Alerts (Portal)

**Goal:** get notified by email when spend in the RG crosses a threshold —
both actual spend and Azure's *forecasted* spend for the month.

**Steps**

1. Portal → your resource group → **Cost Management** → **Budgets** →
   **Add**.
2. Scope: the resource group (it should default to this since you opened
   Budgets from inside the RG).
3. Name: `budget-cost-visibility-lab`. Reset period: **Monthly**. Creation/
   expiration dates: today through ~1 year out.
4. Amount: pick something small and meaningful relative to what you expect
   to spend in this lab (e.g. $10–20). The point is to actually see an
   alert fire, not to model real production spend.
5. Add alert conditions — at minimum:
   - **Actual** cost, threshold **80%**
   - **Actual** cost, threshold **100%**
   - **Forecasted** cost, threshold **100%** (warns you *before* you
     overspend, based on trend)
6. For each alert, add your email directly, **or** (better, do this one)
   create an Action Group first:
   - Portal → **Monitor** → **Alerts** → **Action groups** → **Create**.
   - Name: `ag-cost-visibility-lab`. Add an **Email/SMS/Push/Voice** action
     of type Email with your address.
   - Back in the budget, select this Action Group instead of a raw email —
     this is the reusable pattern real teams use.
7. Save the budget.

**Concepts check:** a budget alert is informational only — nothing throttles
or blocks spend. If you need a hard stop, that's a different mechanism
(Azure Policy + spending limits, or subscription-level guardrails), out of
scope for this lab but worth knowing exists.

**Validate**
- [ ] Budget shows up under Cost Management → Budgets with your threshold
  rules.
- [ ] Action group exists and the budget references it.

**Capture:** `screenshots/02-budget-created.jpeg` and
`screenshots/03-action-group.jpeg`.

**Write-up:** fill in `docs/alerting-strategy.md` now — your threshold
choices and why, while it's fresh.

---

## Module 3: Cost Data Export (Portal)

**Goal:** get raw cost data flowing into a Storage Account so you have
something to point a dashboard or spreadsheet at.

**Steps**

1. Create a Storage Account (Portal → **Storage accounts** → **Create**,
   same resource group, **Standard_LRS**, **StorageV2** kind — globally
   unique name, e.g. `stcostvislab<yourinitials><random>`).
2. Inside it, create a blob **Container** named `cost-exports`.
3. Portal → your resource group (or subscription) → **Cost Management** →
   **Exports** → **Add**.
4. Name: `export-cost-visibility-lab`. Metric: **Cost and usage details**.
   Frequency: **Daily export of month-to-date costs** (cheapest way to see
   data quickly — switch to monthly later if you want).
5. Point the destination at the storage account and `cost-exports`
   container.
6. Save, then use **Run now** so you don't have to wait until tomorrow to
   see a file land.

**Validate**
- [ ] A CSV (or folder of CSVs) appears in the `cost-exports` container
  after running the export manually.

**Capture:** `screenshots/04-cost-export.jpeg`.

---

## Module 4: Visualize (Portal)

**Goal:** a dashboard you can glance at to answer "what are we spending,
and on what?"

**Steps**

1. Portal → **Cost Management** → **Cost analysis**, scoped to your
   resource group. Explore the default view, then group by **Service
   name** and by **Tag**.
2. Pin the views you find useful to a Dashboard: open the **⋯** menu on a
   Cost Analysis chart → **Pin to dashboard** → create a new dashboard
   named `dash-cost-visibility-lab`.
3. Pin at least:
   - Accumulated cost over time (daily)
   - Cost by service name
4. Arrange/resize the tiles so the dashboard reads top-to-bottom by
   importance.

**Validate**
- [ ] Dashboard has at least 2 cost tiles and loads without errors.

**Capture:** `screenshots/05-dashboard.jpeg`.

**Write-up:** fill in `docs/dashboard-design.md` — what each tile shows and
why you chose it.

---

## Module 5: Codify It — Bicep (IaC)

**Goal:** redeploy Modules 1–3 (resource group, action group, budget,
export storage) from code instead of clicks, and understand what each
template does line by line.

The templates are in `infra/`:

```
infra/
  main.bicep                 # subscription-scope entrypoint, creates the RG
  main.parameters.json        # values you fill in
  modules/
    actionGroup.bicep
    budget.bicep
    exportStorage.bicep
```

**Steps**

1. Read `infra/main.bicep` top to bottom alongside the portal steps you
   just did — match each Bicep resource to the portal blade that created
   its equivalent.
2. Copy `infra/main.parameters.json` and fill in your email, a unique
   storage account name, and a budget amount.
3. Validate before deploying (catches typos/schema errors without creating
   anything):
   ```bash
   az deployment sub validate \
     --location <your-region> \
     --template-file infra/main.bicep \
     --parameters infra/main.parameters.json
   ```
4. Preview what would change:
   ```bash
   az deployment sub what-if \
     --location <your-region> \
     --template-file infra/main.bicep \
     --parameters infra/main.parameters.json
   ```
5. Deploy. Use a **different** resource group name in the parameters file
   than Module 1 used, so you end up with both side by side and can compare
   them in the portal:
   ```bash
   az deployment sub create \
     --name cost-visibility-lab-deploy \
     --location <your-region> \
     --template-file infra/main.bicep \
     --parameters infra/main.parameters.json
   ```
6. In the portal, confirm the new resource group has a budget, action
   group, and storage account matching what you built by hand.

**Note on the Cost Management export resource:** the `Microsoft.CostManagement/exports`
API has moved through several preview versions. If `exportStorage.bicep`
fails to deploy with an API/schema error, check the current resource
type and required properties with:
```bash
az provider show --namespace Microsoft.CostManagement --query "resourceTypes[?resourceType=='exports']"
```
and adjust the `apiVersion` / properties in the module accordingly — this
is a normal part of working with Azure's faster-moving preview APIs, not
a sign you did something wrong.

**Validate**
- [ ] `az deployment sub create` completes successfully.
- [ ] The deployed resource group's budget/action group/storage account
  match the hand-built ones.

**Capture:** `screenshots/06-bicep-deployment-success.jpeg` (CLI output or
the deployment's Overview blade in the portal).

---

## Module 6: Cleanup & Cost Control

**Goal:** don't pay for a lab you're done with.

**Steps**

1. Delete both resource groups (the portal one from Module 1 and the
   Bicep one from Module 5) once you've captured what you need:
   ```bash
   az group delete --name rg-cost-visibility-lab --yes --no-wait
   az group delete --name <your-bicep-rg-name> --yes --no-wait
   ```
2. Confirm in the portal that both are gone (deletion takes a few minutes).
3. Check **Cost analysis** at the subscription level one more time to see
   the total spend for the lab.

**Validate**
- [ ] Both resource groups no longer appear under Resource groups.

---

## Module 7: Capstone Write-up

Now turn the lab into portfolio material. Fill in, in this order (each
builds on the last):

1. `docs/lessons-learned.md` — do this first while details are fresh.
2. `reports/cost-visibility-report.md` — the technical writeup.
3. `reports/executive-summary.md` — the same content, compressed for a
   non-technical reader.
4. `reports/stakeholder-email-template.md` — a short email you'd actually
   send announcing this is live.

Each of those files has its own template with prompts — open them and
replace the bracketed placeholders with your real findings and screenshots.
