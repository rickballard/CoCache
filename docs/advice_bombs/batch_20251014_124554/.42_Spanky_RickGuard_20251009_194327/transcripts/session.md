# Session transcript (condensed)

This package summarizes a PS7-heavy repo-hardening/seed-mode session.
It captures intentions, pivots, and the final RickGuard flip-switch tooling.
Key themes: **frictionless seeding**, **automerge (squash)**, **CODEOWNERS notifications**, and **Critical guard on CoCivium™**.

## High-level timeline
- Resolved rebase/merge churn by preferring upstream for CI workflows via `.gitattributes` (`merge=theirs`) and enabled `rerere` for conflict learning.
- Switched repo merge model to **squash-only**, **auto-merge enabled**, **delete branch on merge**.
- Created PowerShell helper functions to set repo-level knobs and branch protection across public repos with tiered policy:
  - **Seed**: minimal friction, CODEOWNERS for notification, permissive branch protection (or none if classic not available).
  - **Critical (CoCivium™)**: require checks `ci/smoke` + `ci/test` and 1 approving review; force-push disabled when API endpoint is available.
- Encountered API differences:
  - Classic branch protection vs Rulesets. Rulesets blocked on private/free. Classic works on public repos.
  - Some endpoints return `404 Branch protection has been disabled` (expected when classic is off).
  - Force-push sub-endpoint not present on all repos.
- Verified: CoCache merge knobs (auto-merge/squash/delete-branch) ON; CoCivium™ classic protection shows required checks + one review.
- Added **CODEOWNERS** `* @rickballard`, PR/Issue templates, and labels (`launch`, `rickguard:on`, `rickguard:off`).
- Added promptable **rg-seed / rg-off / rg-tight / rg-status** helpers; added a **Launch / RickGuard checklist** to reduce operator error.

## Notable pivots
- Fallback from rulesets to classic protection for public repos.
- Added auto branch-name detection before applying protection.
- Hardened piping `--input -` to fix PowerShell quoting on Windows.
- Skipped actions on empty repos / missing default branches to avoid 404 noise.

## What to keep in mind
- During seeding, _notify-first_ via CODEOWNERS, but keep friction low.
- For CoCivium™, keep Critical guard until site stewards take over or site-only editing is enforced.
- `rg-off` keeps Critical set locked while relaxing others.
