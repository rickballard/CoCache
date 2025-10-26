# Continual/Controlled Evolution (CCE) Doctrine

Purpose: unify improvement across CoSuite with measurable value, explicit safety, and explainability.

## Lifecycle & Governance
States: Idea → Proposal → Plan → Initiative → Close.
- Gates add constraints, evidence, and ownership as you move right.
- Human Nudge and Cron jobs use the same scorer/governor.

## Scores
- **Congruence (C 0–1)**: weighted axes (vision, non‑coercion, transparency, interop, reuse, explainability, sustainability). Floors apply to safety axes.
- **Positive Evolution (PE)**: q95(lens•v) × Evidence − (α·Risk + β·Complexity).
- **Drift Risk (DR)**: 0.6·semantic drift + 0.4·contract drift.

Ship only when PE>0 and governor is Green or Yellow-with-sandbox.

## Evidence Levels
E0 opinion → E4 live canary + rollback; Plan/Initiative require E3+. See EVIDENCE_LEVELS.md.

## SDE (Immune Lane)
Separate fast path to contain adversaries: Quarantine→Rollback→KeyRotate→Attest→Hardened. It can freeze meta‑tuning.

## Merge-or-Race (MORP)
Overlap S ≥ 0.75 → Merge. 0.45≤S<0.75 → Champion–Challenger Race with shared evals and EVI stop rule.

## Meta-CCE
Policy parameters self‑tune in shadow within bounds; promote on uplift ≥5% with safety floors respected; two‑key to relax floors.

## Contracts Everywhere
Interfaces/prompts/datasets are contracts with tests. Any failing contract forces Yellow at minimum.

## PRs as Decisions
PR template records: intent, state, C before/after, lens deltas, Evidence level, PE, DR split, Trust‑radius Δ, Kill criteria, Rollback ID.

