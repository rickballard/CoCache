# CoCivium Initiatives Plan — Scope Specification & Twin-Eyes Diagram

## Purpose
This plan outlines two linked initiatives for CoCivium’s post–Grand Migration work:
1. **Scope Specification** — Define the project’s boundaries, priorities, and thematic structure for both internal governance and public-facing clarity.
2. **Twin-Eyes Diagram** — Upgrade the repo landing page visuals to display both process metrics and scope progress in parallel, using twin spider-web diagrams.

---

## Initiative 1 — Scope Specification (High Priority)

### Objective
Create a living document that:
- Defines what CoCivium includes, excludes, and aspires to deliver in initial phases.
- Maps thematic “scope” areas to the document classification hierarchy.
- Serves as a marketing tool during calls-to-action and onboarding.

### Deliverables
- `docs/scope_specification.md` — public-facing version.
- “Taboo Topics Matrix” (private) for internal congruence checks.
- Mapping of themes to classification layers and related metrics.

### Key Tasks
1. Confirm theme list and vocabulary (theme, spoke, readiness).
2. Write the scope doc with in-scope/out-of-scope sections, readiness levels, and phase triggers.
3. Crosswalk themes → classification hierarchy → metric spokes.
4. Set quarterly review cycle with changelog.
5. Integrate scope doc excerpts into README and outreach materials.

### Dependencies
- Grand Migration completion.
- Classification hierarchy doc reference.
- Agreement on readiness scale.

### Priority
**High** — foundational to communication, planning, and progress tracking.

---

## Initiative 2 — Twin-Eyes Diagram (Medium Priority)

### Objective
Add two side-by-side spider diagrams to the landing page:
- **Left Eye:** Process/productivity metrics (CI, Coverage, OFS, LSH, DTI, Throughput, LT(inv), EE).
- **Right Eye:** Scope progress for thematic areas from the Scope Specification.

### Deliverables
- `site/eyes/metrics.svg` (prerendered for README).
- `site/eyes/scope.svg` (prerendered for README).
- `site/eyes/stars.metrics.json` and `site/eyes/stars.scope.json` for curated glowing “stars.”
- JS/CSS for shimmer and tooltips on GitHub Pages version.
- Link-check CI for fallback behavior if targets move or disappear.

### Key Tasks
1. Lock final metric and theme lists (short labels + abbreviations).
2. Design twin-eye SVG geometry (match existing spider style).
3. Curate initial static star sets (6–10 per eye).
4. Implement shimmer + hover tooltips (Pages only).
5. Configure fallback logic for removed/renamed files.
6. Document star curation workflow in `site/eyes/README.md`.

### Dependencies
- Scope Specification completion (for theme eye).
- Existing metric set for metrics eye.
- GitHub Pages mirror for interactivity.

### Priority
**Medium** — impactful for outreach and engagement; can follow scope doc.

---

## Sequencing

**After Grand Migration:**
1. **Day 1:** Scope Specification drafting + internal review.
2. **Day 2:** Scope Spec public version finalized + excerpt integration into README.
3. **Day 3–4:** Twin-Eyes Diagram design + static star set creation.
4. **Day 5:** Pages interactivity (shimmer, tooltips), link-check CI.

---

## Governance

- Both initiatives reviewed and approved under HumanGate.
- Scope Specification major revisions require assembly-level approval.
- Eyes diagram updates (stars, labels) require PR with `eyes-star` label.

---

_Last updated: 2025-08-13_
