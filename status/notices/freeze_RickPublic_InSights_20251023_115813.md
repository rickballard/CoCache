Title: Coordination Notice — “RickPublic / InSights speeches regimes”
Dates: Freeze through end-of-day Thu Oct 30, 2025 (America/Toronto)

Objective:
- Stand up a “State of the World” (SOTW) repackaging stream using RickPublic as publisher and CoCivium/insights as SoT index.
- Bind posts to CoSuite assets by ID (no duplication); Substack distribution via manual paste.

Freeze scope (no edits/renames/moves; no mass formatting)
- CoCivium: /insights/** and /insight/**
- RickPublic: /sotw/** , /indexes/** , /advicebombs/2025-10-23_RickPublic_AI_Access_v3/** , /tools/** , /scripts/**

Allowed:
- Everything else; CoCache/metrics/web assets ok if they don’t write into frozen folders.

Expected changes from this session:
- RickPublic: (commits and scaffolds as listed in the notice)
- CoCivium: read-only enumeration of insights trees.

PR / hygiene:
- main protected; PRs only for scoped paths; squash-merge; no force-push.
- If proposing changes to frozen paths: open PR labeled “[HOLD] — respect-freeze”.

Exit criteria:
- SOTW #0001 merged (rickpublic/sotw/0001-sachs) with post.md + meta.json
- insights-index.json populated & referenced by #0001
- SUBSTACK_MAPPING.md + TEMPLATE_post.md validated with first post

