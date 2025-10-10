# CoAgent MVP – Product Requirements (PRD)

## Goal
Ship a local-first coordination layer that safely orchestrates two Chat sessions against a repo using a CoTemp bridge, upgradeable to full CoAgent.

## Personas
- **Solo Maintainer (you)** – reliable multi-pane flow without conflicts.
- **Contributor (Elias)** – joins later; clear prompts, safe guardrails.

## Must‑have (MVP)
- One watcher per session, DO/Note bridge, YAML‑guarded DOs.
- Packaging: signed ZIP; README_FIRST; post‑install smoke DO.
- Logs + simple status script.

## Nice‑to‑have
- Lockfile/debounce, auto compaction, conflict hints.

## Out of scope (MVP)
- Cloud backplane, multi‑agent policy engine, UI installer.

## Success metrics
- ≤1min cold start to “smoke pass” on clean machine.
- 0 duplicate watchers after relaunch (checked via status script).
- 100% of DOs contain valid headers; 0 secret leaks in logs.
