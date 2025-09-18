# Policy: Scheduler Prohibition for Complex Workflows

**Rule:** Do not use the ChatGPT in-app “scheduled tasks” for production workflows.
Allowed only for trivial, disposable reminders (e.g., single ping within 24h).
**Prohibited** for any multi-step, repo-touching, or recurring orchestration.

**Why**
- Rate/limit banners correlate with session bloat & tool flakiness.
- Hard to audit/version; can’t be reviewed or diffed in git.
- Increases risk of runaway background behavior.

**BloatSignal Link**
- If the UI shows “You’ve reached your limit for scheduled tasks…”, trigger `AutoLimitBanner` protocol (High risk; handoff).

**Approved Alternatives**
- CoCache-based playbooks + local/watch scripts.
- Single external aggregator job (hourly default) that batches checks/notifications.
- Manual triggers via DO blocks when appropriate.

**Enforcement**
- Default max in-app tasks per session: **0**.
- Any exception must be documented in PR description + added to `bpoe-status.md`.
