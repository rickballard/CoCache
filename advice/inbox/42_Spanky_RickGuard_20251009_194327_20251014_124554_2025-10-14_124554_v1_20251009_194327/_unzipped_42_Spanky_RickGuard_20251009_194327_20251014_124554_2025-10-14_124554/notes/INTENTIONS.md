# Intentions

- Seed-stage repos should be **easy and low-resistance** for the owner while still safe for future contributors.
- Use **RickGuard** switch to move between:
  - **Seed**: minimal branch protection; CODEOWNERS for notify-first.
  - **Critical** (CoCivium): required checks `ci/smoke`, `ci/test` and 1 review; block force-push when available.
  - **Off**: relax protections for launch windows, but still hold Critical set.
- Keep **CoCivium** guarded until the website/stewards can assume repo edits, possibly site-only editing later.

## Unfinished
- [ ] Expand Guarded middle-tier for staging repos (define checks).
- [ ] Decide which additional repos join the Critical set at launch time.
- [ ] Formalize notification hooks (e.g., actions that post to chat/email on first-time contributors).
