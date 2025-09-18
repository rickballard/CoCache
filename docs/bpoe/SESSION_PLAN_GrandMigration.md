---
doc: GrandMigration Session Plan
session: Grand Migration (this panel)
owner: GPT-5 Thinking (ChatGPT) + Chris
created_local: 2025-09-18T23:11:36Z
ttl_days: 14
version: v1
---

# Grand Migration — Session Plan & Checklist

## Scope (this session)
- Centralize BPOE/IssueOps docs in **CoCache** (reusable, slim shims).
- History hygiene: remove ≥100MB blobs; install **Blob Guard** guidance.
- Formalize **CoTemp** handoff pattern (inter-session comms).
- Prepare **Civium deprecation** (private+archived) with safe rollback.
- Produce a **Leftovers Register** and a **Generic Advisory** template for other sessions.
- Leave multi-repo polish to a follow-up sweep session.

## Out-of-scope (for follow-up session)
- Deep multi-repo refactors/polish.
- Product hardening for **CoAgent MVP** (handled by Productization session).
- InSeed site / profile alignment work (handled by Profile session).

## Definition of Done (close & succeed this session)
- [ ] BPOE/IssueOps docs present in CoCache, linked from README index.
- [ ] Blob-guard docs & pre-push hook example available in CoCache.
- [ ] CoTemp handoff watch/paths documented.
- [ ] Leftovers Register created and seeded with items (if any).
- [ ] Generic Advisory/Handoff template published.
- [ ] Civium deprecation runbook published (with checked preflight steps).
- [ ] Final handoff note dropped to Productization & Sweep sessions.

## Risks / Mitigations
- History rewrite surprises → **Backups** (.bundle) & tags; force-push with lease; communicate broadly.
- Hidden large files reappear → use **Test-GitBigBlobs** gate and pre-push hook.
- Cross-repo link rot → leave redirects/notes in CoCache and deprecation README.

## Deliverables
- docs/bpoe/SESSION_PLAN_GrandMigration.md (this file)
- docs/bpoe/HANDOFF_TEMPLATE_GenericAdvisory.md
- docs/migration/LEFTOVERS_Register.md
- docs/bpoe/DEPRECATE_Civium_Runbook.md

## Handoffs
- To Productization (CoAgent): backend interceptor status, OmniBar v2 wiring notes.
- To Sweep session: runbook pointers + leftovers list.

## Rollback
- Reuse .bundle backups; unarchive Civium if needed; revert branch protections.
