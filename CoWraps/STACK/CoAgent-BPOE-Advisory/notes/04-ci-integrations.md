# CI Integrations (Minimal)

- `bpoe-sanity.yml` performs *only* non‑sensitive presence checks:
  - Enforce AB‑bypass marker exists in hook and **not** elsewhere.
  - Ensure BPOE playbook contains paste‑safe marker.
  - Ban literal `<branch>` placeholders and `exit 0` in docs.
- CI logs contain only filenames; mask workspace path if possible.
- Keep artifact retention **0–1 days** or disabled.
- Use branch protection to require the check; do not encode heuristics in CI.
