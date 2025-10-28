# BPOE Changelog (evolution notebook)

_Auto-seeded 20251028_233414Z — capture workflow learnings and guards as they land._

## 20251028_233414Z
- **Prior-Art Gate v1.1.2**: README badge; `PRIORART_ACK` label; non-blocking local pre-commit nudge.
- **Helpers Registry**: `public/bpoe/HELPERS_REGISTRY.json` + `.md` generated from `tools/**` with SHA1s, funcs, tags.
- **Patience UX ("second dots")**: canonical `tools/UX/CoPatience.ps1` + `docs/ux/CoPatience.md`; prefer evolve-over-new via SESSION_PLAN gate.
- **DO-block hygiene**: CI workflow `bpoe-doblock-lint.yml` + `tools/BPOE/Scan-DoBlocks.ps1` to enforce here-string rules.
- **Merge Train**: runner improved to accept multiple `-PR` forms; prefer **auto-merge (squash + delete)** for green PRs.
