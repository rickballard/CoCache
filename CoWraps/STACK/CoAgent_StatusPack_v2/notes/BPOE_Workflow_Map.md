# BPOE / Workflow Map (pre‑CoAgent runtime)

1. **Panels & Sessions**: Friendly panel names (Planning/Migrate) map to session IDs; persisted as JSON under `Downloads\CoTemp\panels`.
2. **Watchers (one per session)**: Background jobs monitor `sessions/<id>/inbox`. Stable‑file gate + header validation. Logs to `logs/`, audit JSON to `outbox/` if used.
3. **DO files**: PowerShell snippets with a YAML header (title, repo, risk, consent). Safe by default; writes/network must be explicitly set true.
4. **Notes**: Plain text one‑liners for status pings.
5. **Launcher**: Registers panels, starts exactly one watcher per session, opens two Chat tabs, and primes clipboard with greetings.
