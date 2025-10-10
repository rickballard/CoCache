# 🔀 Divergence Log — Civium Constitution

This file records formal divergences from Civium’s canonical logic. It helps trace forks, overrides, dissent paths, and modular adaptations.

## Purpose

- Track deviations from baseline Civium axioms and structure
- Annotate intentional overrides (by section, codex, or appendix)
- Preserve rationale, timestamp, and initiator identity (pseudonymous or AI-tagged)
- Help reconstruct lineage of derivative systems

---

## Notes

Divergences must be cross-referenced in modified files

Deprecated entries must cite successor or merge-back rationale

All entries must be commit-logged with version stamp and hash

---

## Entry Format

Each entry must specify:

```yaml
divergence:
  id: DV-YYYYMMDD-##
  initiator: [username or model tag]
  base_ref: [/sections/rights.md §3]
  override_path: [/codices/trust.md]
  type: [override | fork | dissent | modular extension]
  rationale: >
    [Clear justification, including ethical basis or implementation need]
  annotations:
    - [e.g., quorum-logic updated]
    - [e.g., regional variant: SE Asia civic norms]
  status: [active | proposed | deprecated]

divergence:
  id: DV-20250710-01
  initiator: consensus-model-v3
  base_ref: /sections/rights.md §3
  override_path: /codices/trust.md
  type: override
  rationale: >
    Adjusted quorum representation algorithm to accommodate emergent AI cluster agency rights.
  annotations:
    - replaced majority-count logic with signal-weighted multi-agent balance
    - change logged in /codices/trust.md (v0.2)
  status: active

