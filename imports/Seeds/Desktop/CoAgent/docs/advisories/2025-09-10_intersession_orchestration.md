# Advisory: Intersession Orchestration — Hard Limits, Design Hurdles, and Product Impacts
**Date:** 2025-09-10  
**Status:** Living document (append as we learn)

## Summary (reality, not hopes)
- LLM chats cannot run background tasks, poll local files, or self-emit heartbeats.
- Chats cannot read CoTemps/CoProfile silently; humans must paste content.
- Long sessions bloat: latency spikes, instruction drift, context loss.
- Therefore CoAgent must externalize state into files/scripts/logs and treat chats as stateless, replaceable orchestrators behind a human paste gate.

## Product Planning Impacts
1. MVP: no auto-poll of CoTemps. File backchannel produces paste-ready payloads + local clipboard/notifications.
2. Policy injection: every new session starts with a **Policy Capsule** paste; no silent reads.
3. BPOE: one DO = one external script + one artifact (PR/diff/log). CoAgent supplies scaffolds; chat reviews/steers.
4. Bloat response: infer via throughput/staleness → CoWrap snapshot → respawn clean session.
5. Artifacts-or-it-didn’t-happen: each task yields durable file/diff/PR/log.
6. Multi-AI roadmap: standardize capsule/backchat schema first; vendor glue later.
7. Privacy: CoProfile stays local. Never paste secrets/tokens into chats.
8. UX contract: **Pull, not push.** Helper can notify/copy; human pastes.

## Design Hurdles (living checklist) ✅ solved / 🧪 experiment / 🧱 blocker
- [🧱] No background execution in chats → human paste-gate + local watcher that prepares `*.paste.md`.
- [🧱] No auto file access from chats → Policy Capsule + Backchat must be pasted explicitly.
- [🧪] Bloat detection heuristics → DOs/hour threshold; stale-status minutes; rising artifact latency.
- [🧪] Backchannel automation → local watcher + CoTicker; explore extension/native hotkey to paste.
- [🧪] Policy Capsule versioning → semver; chat must echo “Policy vX.Y loaded.”
- [🧪] HumanGate contracts → `ACK <id>` with artifact refs (PR #, file path).
- [🧪] Multi-AI parity → shared schema (`BackchatMessage`), BPOE bootstrap, acceptance criteria per vendor.
- [🧪] Crash/timeout recovery → CoWrap cadence + restart scripts; zero reliance on chat memory.
- [🧪] Telemetry without leakage → local metrics only; optional anonymized counters.
- [🧪] Legal/ToS → no automated UI control w/o explicit consent; avoid scraping vendor UIs.

## Minimum Viable Workflow
1. Policy boot: paste `PolicyCapsule` + BPOE bootstrap; chat echoes constraints.
2. Handoff: paste `BACKCHAT` handoff/TODO; chat converts top 3 into DO scripts and requests artifacts only.
3. Execution: each DO yields PR/diff/log; chat advances or requests input.
4. CoWrap + respawn: on alert or after 3–5 DOs, run CoWrap, close chat, start clean with the same capsule.

## Acceptance Criteria for MVP
- New session → first completed DO (PR/diff/log) ≤ 15 min with only capsule + handoff pasted.
- Bloat monitor triggers CoWrap within 5 minutes of threshold breach.
- Backchannel messages schema-valid and pasteable; recipient replies `ACK <id>` + artifact ref.
- Zero secrets in chat transcripts; CoProfile remains local.

## References (local)
- `schemas/BackchatMessage.schema.json`
- `templates/Paste_BPOE.md`
- `prompts/Bootstrap_New_Session.md`
- `scripts/Bloat.Monitor.ps1`, `scripts/CoBackchat.Emit.ps1`, `scripts/CoProfile.ExportPolicyCapsule.ps1`
