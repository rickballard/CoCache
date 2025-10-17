# Idea Card — CoEvolution of Documents (CoGenetics / “CoGenes”)
**Timestamp:** 2025-09-16 05:18


## Problem / Opportunity
CoCivium’s living documents (constitution, policies, guides, specs) need a way to **evolve without losing legitimacy**. Some sentences/clauses become culturally “sticky” and shouldn’t be casually changed; others should remain experimental. We need a model that encodes **lineage, stability, and consent** so change is fast where safe, and gated where sensitive.

## Core Concept: CoGenes
- **CoGenes** = smallest stable units of meaning (phrases/clauses/sentences) that recur, get quoted, and accrue legitimacy.
- Each CoGene tracks **lineage** (first seen, parents/variants), **adoption** (citations/reuse), **status** (tier), and **constraints** (who/how to change).
- External label if needed: **Content Lineage Units (CLUs)** to avoid biological framing in UX.

## Sensitivity Tiers (change thresholds)
- **Experimental** — freely editable (AI/humans); reversible; auto‑tagged.
- **Draft** — minor edits: 1 reviewer; major edits: 2 reviewers.
- **Established** — steward quorum required; change record mandatory.
- **Canonical** — community vote (e.g., ≥50% turnout & supermajority), immutable audit trail, scheduled review windows.

> Promotion/demotion uses adoption/controversy scores + stewardship proposals.

## Governance & Gates
- **Human‑Gate** for any change that alters meaning of Established/Canonical CoGenes. Routine fixes (typos/formatting/links) stay autonomous.
- **Decision provenance** per change: `human | ai | hybrid` + rationale; pseudonymous human IDs allowed, but logged.
- **Appeals & rollback** windows; emergency rollback authority with post‑hoc review.

## Metadata / Schema (MVP)
Per CoGene (sidecar JSON/YAML or front‑matter map):
```
id, hash, first_seen, last_modified,
status, adoption_score, stability_index,
provenance {authors, ai, hybrid},
constraints {reviewers, vote_rules},
links {parents, variants, children},
ethics_flags, bp_alignment {score, sources}
```
Repo files maintain `*.cogene.json` span maps; org‑wide registry at `/cogenes/registry.jsonl`; events at `/cogenes/events.jsonl`.

## UX (avoid rainbow doc bodies)
- **Hover chips / gutter icons** showing status + lineage; badges like `◩ Established`, `ⓒ Canonical`.
- **CoGene‑aware diffs**: show impacted units, not just line ranges.
- Compact footers: best‑practice alignment, ethics flags, status.

## Maturity Stages (ties rules to lifecycle)
- **Seed** — AI can bulk‑generate experimental text; minimal gates; fast iteration.
- **Foundation** — elevate frequently cited units; start applying tier rules.
- **Launch** — introduce Canonical tier + community voting; rate‑limit AI authorship to preserve human voice.
- **Post‑Launch** — periodic “canon audits”; community can tune thresholds.

## Hybrid Minds & Biotech (CoGenetics scope extension)
- **Natural → Intentional Evolution**: consent‑based cognitive/biotech upgrades (neural co‑processors, symbiotic implants).
- **Guardrails**: consent‑before‑coercion, transparency, safety/reversibility, identity/rights handling.
- CoGenes also govern **policies for hybrid citizenship**, identity, rights, and upgrade governance.

## Best‑Practice Alignment
- Maintain a **Best Practices Registry**; each CoGene carries a `bp_alignment` score + source refs.
- Misalignment triggers review; alignment does not auto‑canonize.

## Deliverables from this Idea
1. **CoGenetics Explainer** (short doc) linking to constitution/governance.
2. **Schema**: `/schemas/cogene.schema.json` + sidecar format `*.cogene.json`.
3. **Policy**: Sensitivity Tiers & edit thresholds.
4. **Governance Spec**: voting, quorums, windows, supermajorities, rollback, appeals, immutable trails.
5. **Procedure**: Human‑Gate & Steward roles; hybrid decision logging.
6. **UX Spec**: hover chips, badges, CoGene‑aware diff view.
7. **Maturity Matrix**: Seed→Post‑Launch rule toggles.
8. **Appendix**: Hybrid Minds/biotech guardrails + crossover policies.

## Immediate Next Steps (defer implementation details to planning)
- Draft v0 schema; tag 1–2 anchor docs with sidecars as exemplars.
- Add PR gates for Established/Canonical edits; log `decision_type` in PR template.
- Schedule quarterly **canon audit** report.

---
**Intent:** Capture the essence of this session for later execution. No hard decisions on exact numbers/time windows here; those belong in the Governance Spec PR.
