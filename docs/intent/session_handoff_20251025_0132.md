# CoSync Handoff Summary
**When:** 2025-10-25 01:32:39Z (UTC)

## Artifacts (AdviceBombs ingested)
| file | bytes | sha256 |
|---|---:|---|
| RP_AdviceBomb_v1.zip | 2620 | B0323B4E6919FE1A6090FF80EE7B141F5D063933E150122AC3ABC646C91C3399 |
| AdviceBomb_CoTheory_Mythos_20251024.zip | 2177 | 22536F4EDBFAE8E918ED689007F0AD99FE34D260BA7AAAE2EAAF91AB37B797CE |
| AdviceBomb_CoAgent_Outreach_CLRIM_20251024_124930.zip | 10871 | 682D92EC3744961E9C244511173FEDC9944B3607B1327BFD4DE6A7FBC47559D5 |
| Advice_SeedCrystal_20251024_153510.zip | 3179 | CEA1FF83C8200616CF8B0870621D26967F29B48BF5D685BE3B39C65948A6E32E |

## Workflows & tools created/updated this session
• CoCache: `docs/COSYNC_SCHEMA.md` (receipt schema)
• CoCache: `tools/Housekeep-Bloat.ps1` (light, non-blocking)
• CoCache: `tools/Mirror-AdviceBombs.ps1` (PR-based mirror to CoAgent)
• CoCache: `tools/Systematization-Scan.ps1` + CI `.github/workflows/systematization-scan.yml`
• CoCache: CoSync feed generator (daily) `.github/workflows/cosync-feed.yml` and `site/cosync_feed/top50.json`
• CoCivium: hero spider monthly CI `.github/workflows/hero-monthly.yml`
• CoSteward: README live “Recent-50” CoSync widget

## Open items / next steps (prioritized)
1. **CoAgent AdviceBomb PR:** ensure mirrored zips are in the PR branch; merge after checks.
2. **Hero spider:** monthly via CI; consider sourcing metrics from CoCache dashboards for faster render.
3. **CoSync Feed:** verify daily job publishes `top50.json` and `mega.jsonl`.
4. **Systematization intake:** review `docs/dashboards/systematization_scan.csv`; shortlist candidates to ingest.
5. **Identity fields:** adopt `docs/COSYNC_SCHEMA.md` across emitters (user/session/actor/run).
6. **Housekeeping:** ensure `Housekeep-Bloat.ps1` runs at the end of every emit.

## Notes
- Local CoSync cleanup uses quick `git maintenance` (no PS7 hangs).
- Heavy git GC runs only in CI to avoid blocking your shell.
- Protected branches use PR flow.

