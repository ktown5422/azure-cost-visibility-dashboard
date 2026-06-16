# Lessons Learned

This file is meant to be filled in after you've actually run through `docs/setup-steps.md` against a real subscription - a lessons-learned doc written before doing the work is just speculation. Below are the two genuinely true lessons from *building* this repo, followed by prompts to answer once you've deployed it.

## From building this project

- **Empty placeholder files are a trap.** The first two commits to this repo created `docs/*.md` and `reports/*.md` as empty files. Empty files look like progress in a commit log but carry zero information - better to either write the real content immediately or not create the file until you have something to put in it.
- **Don't ship unverified specifics as fact.** While designing the workbook, the exact JSON shape for querying the Cost Management API directly from a Workbook's ARM data source couldn't be confirmed against live docs in this session. Rather than fabricate a plausible-looking but unverified schema for the centerpiece chart, that idea was dropped in favor of Resource Graph queries that were verified against a real deployed example (see `docs/dashboard-design.md`). Confident-sounding wrong IaC/JSON is more expensive to debug later than an honest "not verified yet."

## To fill in after your first real deployment

- **Budget alerts**: How long did it actually take from crossing 50% spend to the email arriving? Did the forecasted-100% alert fire before or after actual spend caught up?
- **Cost exports**: What did the first CSV in `cost-exports` actually contain? Any columns you expected that weren't there, or vice versa?
- **Governance queries**: Did `untagged-resources.kql` / `orphaned-managed-disks.kql` / `unassociated-public-ips.kql` surface anything real? Any false positives worth filtering out?
- **Workbook**: Did the workbook JSON import and render cleanly, or did you have to fix something in the Advanced Editor? If so, what, and is the fix folded back into `workbooks/cost-visibility-workbook.json`?
- **Cost vs. effort**: How much did running this lab itself cost (storage account, any test resources)? Worth knowing for anyone repeating this exercise.
- **What would you change**: with hindsight, what would you design differently in `infra/` or the workbook?
