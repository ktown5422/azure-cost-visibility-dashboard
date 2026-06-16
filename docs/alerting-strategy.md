# Alerting Strategy

> Filled in during Module 2 of `setup-steps.md`. Replace the bracketed
> placeholders with your actual decisions — the structure/questions below
> are guides, not the deliverable itself.

## Scope

- **Scope of the budget:** [resource group / subscription — which one, and
  why that scope made sense for this lab]
- **Budget amount:** [$X / month] — [why this number: arbitrary lab cap?
  modeled on an expected workload?]
- **Reset period:** Monthly

## Thresholds

| Type | Threshold | Rationale |
|---|---|---|
| Actual | 80% | [e.g. early warning while there's still room to react] |
| Actual | 100% | [e.g. confirms the budget was exceeded] |
| Forecasted | 100% | [e.g. catches a runaway trend before month-end, not after] |

[Add/remove rows to match what you actually configured.]

## Notification path

- **Action group:** `ag-cost-visibility-lab`
- **Receivers:** [email(s) configured]
- **Why an action group instead of raw emails on the budget:** [e.g.
  reusable across multiple alerts, easier to update one place if the
  on-call contact changes]

## What this strategy does *not* cover

- Budgets are notify-only — they don't block spend. [Note here whether you
  looked into Azure Policy / spending limits as a follow-up, even if you
  didn't implement it.]
- [Any other gaps you noticed — e.g. no alert on anomalous single-resource
  spend, no Slack/Teams integration, etc.]

## What you'd change for a real production subscription

[A few sentences — e.g. per-team budgets via tags, escalation tiers, a
webhook into an incident tool instead of just email.]
