# CoProfile – Local-first preference profile (CoModule)

**Goal.** Give users a private, repo-backed profile that AIs and tools can read locally. No cloud memory required. Designed for CoAgent/CoModules, works standalone.

## Why now
- Chat 'memory' is small, opaque, and ephemeral.
- Regulated or privacy-sensitive users need local control.
- CoAgent needs a clean, portable "user context" to apply policies consistently across repos and devices.

## MVP (week 1)
1. Spec + schema (`schemas/copref.v0.(yaml|json)`) and loader (`scripts/CoProfile.psm1`).  
2. Local editor UX: simple README with documented keys; optional `Show-SetupToast.ps1` preview.  
3. DO adapters for CoTemp (drop smoke DO, log engine/version).  
4. Exporters: to JSON for other tools.

## v0.2 (weeks 2–3)
- Optional **CMS** encryption for private fields.
- Small "profile inspector" UI (PS host) that explains which keys influence behavior.
- Opinionated defaults for CoAgent (sections, DO/ADVISORY, DEC now/next/later).

## v1 (commercial)
- Guided onboarding.
- Bundled policy packs (e.g., privacy-first, compliance-first).
- Teams mode: merge personal + org profiles with conflict visualization.
- Monetization: one-time license or support subscription.

## Privacy & security
- The profile lives in a normal folder (e.g., `~/Documents/CoProfile/`).  
- Secrets are **not** stored here. Private overrides can be CMS-encrypted (`secrets/`), optional.  
- Git is encouraged for versioning; repo can be private or local-only.

## Integration points
- CoTemp watchers read `coprofile.(yaml|json)` to set defaults (session, tag, inbox).  
- CoAgent and CoModules consult `style` and `bpoe` sections for output formatting and BPOE policy.  
- Editors and scripts show a small status window during setup to avoid “ghost windows”.

## Deliverables in this seed
- Schema, examples, a loader module, and a DO smoke test.
- A plan for task scheduling improvements (delayed-at-login launcher).

---

**Status:** Seed kit generated 2025-09-10T15:59:52.  
