# Alerting Strategy

## Thresholds

`infra/modules/budget.bicep` defines three notifications on the budget:

| Notification | Type | Threshold | Why |
|---|---|---|---|
| `Actual_GreaterThan_50_Percent` | Actual | 50% | Early warning while there's still runway to course-correct before month end |
| `Actual_GreaterThan_80_Percent` | Actual | 80% | Last reasonable point to act before the budget is blown |
| `Forecasted_GreaterThan_100_Percent` | Forecasted | 100% | Catches a budget overrun *before* it happens, based on Cost Management's own forecast, not just trailing spend |

Three tiers rather than one because a single 80%-actual alert gives no lead time if spend is front-loaded early in the month, and a single forecasted alert gives no signal once the month is nearly over and forecasting becomes unreliable. Using both actual and forecasted thresholds covers early-month and late-month blind spots respectively.

## Delivery path

All three notifications point at one action group (`ag-cost-visibility`, `infra/modules/actionGroup.bicep`) with a single email receiver. Centralizing on one action group means adding a new budget (e.g. per environment or per team) is just pointing another budget resource at the same action group - the notification channel and the cost-tracking boundary are decoupled.

## Known limitations to design around

- **Evaluation latency**: budgets evaluate roughly every 8 hours, and a notification can take up to 24 hours to fire after a threshold is crossed. This is a lagging signal, not a real-time one - don't rely on it to catch a runaway resource within the hour. For that, pair it with Azure Monitor cost anomaly alerts or a tighter per-resource budget.
- **Currency/locale**: `amount` is in the subscription's billing currency with no FX conversion; if you operate across subscriptions in different currencies, each needs its own budget with its own threshold tuned to that currency.
- **Single email receiver**: fine for a personal lab. For a team, extend `actionGroup.bicep` with an SMS or webhook receiver (e.g., a Logic App posting to Teams/Slack) rather than fanning out to multiple personal emails.

## Extending this

- **Per-team budgets**: deploy `infra/modules/budget.bicep` multiple times with a `filter` added to `properties` (e.g., scoped to a tag value), one per cost center, all pointed at team-specific action groups.
- **Escalation**: add a second, higher-severity action group (e.g., paging a manager) used only by the `Forecasted_GreaterThan_100_Percent` notification, since that one represents an actual incoming overrun rather than an early warning.
