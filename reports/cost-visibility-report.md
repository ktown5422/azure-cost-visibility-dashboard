# Cost Visibility Report: [Project/Subscription Name]

> Template for Module 7 of `setup-steps.md`. This is the technical
> writeup — assume the reader is another engineer.

## Summary

[2-3 sentences: what was built, what it does, current status.]

## Scope

- Subscription: [name/ID, redact if sharing publicly]
- Resource group(s): `rg-cost-visibility-lab` (and the Bicep-deployed one)
- Time period covered: [date range]

## What was deployed

| Component | Purpose |
|---|---|
| Resource group + tags | Cost attribution boundary |
| Budget (`budget-cost-visibility-lab`) | Alerts at 80%/100% actual, 100% forecasted |
| Action group (`ag-cost-visibility-lab`) | Email notification target |
| Cost export → Storage Account | Daily CSV export of usage/cost detail |
| Dashboard (`dash-cost-visibility-lab`) | Accumulated cost + cost-by-service views |
| Bicep templates (`infra/`) | Codified, repeatable version of the above |

## Findings

[What did the cost data actually show once you had visibility into it?
e.g. which service was the biggest driver, any surprises, whether the
budget alert actually fired and what that felt like.]

## Screenshots

[Reference the files in `screenshots/` in order, with a one-line caption
each.]

1. `01-resource-group-created.jpeg` — [caption]
2. `02-budget-created.jpeg` — [caption]
3. `03-action-group.jpeg` — [caption]
4. `04-cost-export.jpeg` — [caption]
5. `05-dashboard.jpeg` — [caption]
6. `06-bicep-deployment-success.jpeg` — [caption]

## Limitations / known gaps

[Pull from `docs/alerting-strategy.md` and `docs/dashboard-design.md` —
what's not covered, what you'd build next.]

## References

- `docs/alerting-strategy.md`
- `docs/dashboard-design.md`
- `docs/lessons-learned.md`
- `infra/`
