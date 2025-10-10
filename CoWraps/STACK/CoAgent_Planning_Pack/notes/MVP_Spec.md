# CoAgent MVP — Scope & Milestones

## Goals
- Two-session coordination (Planning / Migrate) using CoTemp.
- Policy-gated execution of DO blocks with clear consent headers.
- Minimal packaging so a contributor can get running in <10 minutes.

## What’s In
- Panel registry & single-watcher enforcement
- DO/Note bridge + stable-file gate + YAML header check
- Logs (+JSON audit) per DO execution
- Greetings launcher that opens two Chat tabs

## What’s Out (post-MVP)
- Cloud backplane & multi-user scaling
- Full conflict adjudication; consensus across N agents
- Signed installers with auto-update

## Milestones
1) **Runtime hardening** (today → week 1)
   - Enforce single watcher per session (job guard + registry repair)
   - Debounce & lockfile, log rotation
2) **DX polish** (week 1 → week 2)
   - Starter kit ZIP + README_FIRST
   - Smoke DO + test harness
3) **Pre-alpha** (week 2)
   - 2-testers (you + Elias), record issues, iterate
