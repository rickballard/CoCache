# Decisions
- Patched orchestrator “empty pipe element” by inserting `$_ | …` and removing dangling `|`.
- During rebase: kept remote orchestrator; preserved our docs; `.gitignore` ignores `.bak_*` backups.
- Pair-file key normalized (non-word chars → `_`).

