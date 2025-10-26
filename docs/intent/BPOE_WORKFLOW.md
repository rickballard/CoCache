# BPOE Workflow (living)

_Last updated: 2025-10-25T14:17:21_

## AdviceBomb Drops
- Versioned names: `topic-vN.md` or `topic_vN_YYYYMMDD_HHMMSS.zip`
- Pre-push CoEvo: 2–3 loops
- Verify landing:
  1. confirm on repo page
  2. HEAD check raw URLs

## Ingestion (CoPrime)
- Run tools/Integrate-AdviceBombs.ps1 → updates advice.index.{json,md}
- Size ≤256 KB; cadence ≤1 commit / 30m
- Families grouped by stem; inbox can be cleaned after 90d; history in processed/archive

## Known Gotchas
- Avoid inline `V("text {0}" -f $x)` → prefer `$t="..."; V $t`
- Never leave half-lines like `C:\...\advice.index.json = Join-Path (...`
- Close here-strings cleanly

