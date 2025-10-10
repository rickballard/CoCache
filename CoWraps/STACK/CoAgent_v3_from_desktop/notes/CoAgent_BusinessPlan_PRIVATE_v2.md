# CoAgent — Investor Brief (PRIVATE)

**Status:** 2025-09-10T21:33:59.500816
**Owner:** Chris
**Audience:** Prospective angels/partners (NDA or private share only)

## 1) Narrative & Why Now
- Development has shifted to multi-session, multi-agent workflows. Safety, provenance, and conflict avoidance are table stakes.
- CoAgent meets this with a local, air-gapped-friendly runtime that graduates cleanly to policy-gated team orchestration.

## 2) Problem (Buyer Pain)
- Clashing automations and duplicate watchers cause errors and rework.
- Missing **consent & provenance** blocks enterprise adoption of generic agents.
- No clean **two-pane** (plan/execute) ritual with auditable handoff.

## 3) Solution (What We Do)
- **Local coordination now → Policy gates → Conflict awareness → Provenance ledger.**
- **File-queues + DO/Note** primitives, one watcher per session, human-in-the-loop.
- Evolves without retraining users: the same motions scale up.

## 4) Target Users & Beachhead
- Solo builders and OSS contributors (seed and learn), expanding to small teams.
- Windows-first beachhead (your working path), then cross-platform.

## 5) Product Roadmap (Staged)
- **S0 (now):** CoTemp runtime, DO/Note bridge, launcher, status tooling.
- **S1 (MVP):** packaging, consent prompts, debounce/lockfile, compact-on-exit, minimal telemetry.
- **S2:** policy packs, conflict heuristics/prompts, repo intents.
- **S3:** team orchestration, integrations, managed “CoAgent Cloud”.

## 6) Business Model (hypotheses)
- Free local kit (OSS-friendly). Paid: Policy Packs, Team Orchestration, Managed Service.
- Indicative pricing to validate:
  - **Indie** $6–$10 /mo
  - **Team** $12–$20 /seat/mo
  - **Enterprise** dep/site license

<!-- PRIVATE:BEGIN -->
## 7) Secret Sauce (PRIVATE)
- Air-gapped-friendly, reproducible **file-queue** core + **policy gates** ⇒ **provable guardrails** competitors lack.
- Seamless graduation from local → team → managed (distribution & retention moat).
- Conflict heuristics + provenance reduce reviewer load & unlock compliance.
<!-- PRIVATE:END -->

## 8) Market Framing (directional only)
- TAM (devs on VCS/CI): ~50–70M; “coordinated agent workflows” 5–10M.
- SAM (Windows-first indie + small teams): ~0.5–1.5M.
- SOM (first 3 yrs): 5–30k active users.

## 9) GTM
- Seed indie/OSS; “minutes to safe concurrency” demos; starter repos & runbooks.
- Partner showcases; focused content on conflict-avoidance + consent UX.

## 10) 10-Year Scenarios (illustrative)
- **Conservative**: Y10 ≈ $3M ARR; **Base**: Y10 ≈ $13M; **Upside**: Y10 ≈ $50M.
- Drivers: paid team orchestration, policy packs, enterprise provenance.

## 11) Defensibility
- Compliance-grade provenance, policy gates, and editor/repo integrations.
- Migration path moat; operational excellence in conflict management.

## 12) Risk & Mitigation
- UX confusion on watchers → guardrails, tests, docs; single watcher rule.
- Over-permissioning risk → explicit consent, safe-by-default.
- Platform lock-in → cross-platform plan (Electron/PWA) post-MVP.

## 13) Near-Term Use of Funds (if applicable)
- Packaging/UI polish, consent UX, policy packs, cross-platform shell, BD/partners.

## 14) Appendices
- DO header schema, risk flags, sample smokes, architecture & UX diagrams.

---

## Appendix A — Imported notes (verbatim from your desktop bundle)
- We preserved *all* originals under `archive/original_input/`. Review and port highlights into the main sections above.
