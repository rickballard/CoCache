# CoPrime Governance & Continuity Plan (v0.1)

> Source of truth: repo. One CoPrime session at a time. Handoffs via CoSync + Handoff note.

## Goals
- [ ] Single authoritative CoPrime at any time
- [ ] Zero-loss handoffs (intents, plans, progress, BPOE)
- [ ] Repo-first continuity (no reliance on session memory)
- [ ] Low-shim, reversible systemization

## Definitions
- **CoPrime:** the only authoritative session. Others are subordinate taskers.
- **CoSync:** repo-first checkpoint note (already standardized).
- **Handoff Note:** tiny, human-first summary to bootstrap a new CoPrime.

## Policies
- [ ] Start-of-session: `git switch main && git pull --ff-only`
- [ ] Only one CoPrime; announce changes of control in last/next CoSync note
- [ ] All material decisions captured in CoSync/Handoff before break
- [ ] Advice bombs land in `advice/inbox/` + `.sha256` + `advice/INBOX_LOG.md`
- [ ] CI guard stays strict (filename/sha/log/RAW-HEAD + coevo-only needs INBOX_MANIFEST)

## Workstreams
### A. Continuity & Ops Hygiene
- [ ] Maintain daily **CoSync** note (done today)
- [ ] Add **Handoff** note per break or session end (template below)
- [ ] Root README “Ops entry” block links: CoSync folder, Inbox README, CI guard

### B. Intake (Advice Bombs)
- [ ] Keep `.CoVerify.ps1` as the preflight
- [ ] Ensure `.sha256` + `INBOX_LOG.md` same-commit (CI enforced)
- [ ] If only `coevo-1/2/3` present, generate `INBOX_MANIFEST.json`

### C. Systemization (no moves yet)
- [ ] Draft target map for eventual `tools/cosuite/1.0`
- [ ] Enumerate all callsites to repoint
- [ ] Plan deprecation windows (short-lived shims only if unavoidable)
- [ ] Rollback tag prepared before any move PR

## Rollout & Reversibility
- [ ] Each PR: smallest viable change, with check list lines referencing this doc
- [ ] Add “Rollback tag” before risky steps
- [ ] No file moves until target map is approved

## Success Criteria
- [ ] New CoPrime can cold-boot using Handoff + latest CoSync without scrolling chat
- [ ] Inbox consistent on `main`; CI green
- [ ] No orphaned helpers; all entry points discoverable from README

## Appendix — Handoff template (also written to `docs/intent/advice/notes/YYYYMMDD/SESSION_HANDOFF_<UTCSTAMP>.md`)
- Intent backlog (bullets)
- In-flight threads (owner → next step → pointer/PR)
- Decisions today (single lines)
- Risks/blockers
- Pointers (latest CoSync path + inbox/CI/helpers)
