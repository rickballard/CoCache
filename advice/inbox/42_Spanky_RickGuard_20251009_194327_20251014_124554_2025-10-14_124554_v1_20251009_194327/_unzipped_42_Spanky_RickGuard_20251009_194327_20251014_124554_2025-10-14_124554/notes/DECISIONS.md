# Decisions

- Adopt **squash-only + auto-merge** repository model globally for seed repos.
- Use **classic branch protection** where available; fallback gracefully when disabled.
- Install minimal **RickGuard** helpers in `$PROFILE` (`rg-seed`, `rg-off`, `rg-tight`, `rg-status`).
- Add **CODEOWNERS** `* @rickballard` for notify-before-merge behavior.
- Tag launches with labels: `launch`, `rickguard:on`, `rickguard:off` and ship PR/Issue templates.
