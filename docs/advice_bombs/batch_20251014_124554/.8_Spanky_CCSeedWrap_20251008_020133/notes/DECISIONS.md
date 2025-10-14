# Decisions
- Use classic `gh-pages` branch with orphan history for static site.
- Bind custom domain through root `CNAME` file + API `cname` field.
- Versioned DO packages with per-version cache under `%LOCALAPPDATA%`.
- Idempotent seed scripts: create-if-missing; safe to re-run.
