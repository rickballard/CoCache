# CoSync — Outreach Collateral Seed (handoff to CoPrime)
**UTC:** 2025-10-29T19:26:51Z

## Summary
- Outreach AdviceBomb was dropped into CoCache inbox and merged to main.
- CoCache README now links to the seed location.
- Downloadable outreach collateral seed (emails + 5-minute PR handout) is prepared.
- Next: mirror pointers (and optionally files) into CoContrib/outreach; finalize contributor invite flow.

## Pointers
- CoCache seed ZIP folder on main: /advice/inbox/drops/2025-10
- Inbox guard: https://github.com/rickballard/CoCache/blob/main/advice/inbox/README.md
- Contributor checklist: https://github.com/rickballard/CoContrib/blob/main/contributors/elias/ONBOARDING_CHECKLIST.md
- Collateral ZIP SHA256: c663a146b0a055aa2afa8775c86757747a30c46f175cb58d8c4bbf56adcb84c2
- Suggested collateral ZIP name (local copy you downloaded earlier): Outreach_Collateral_Seed_2025-10-29.zip

## Recent work on main
- INBOX_LOG row appended for Outreach AdviceBomb.
- Files present:
  - advice/inbox/drops/2025-10/AdviceBomb_Outreach_CoCivium_20251029-170644Z.zip
  - advice/inbox/drops/2025-10/AdviceBomb_Outreach_CoCivium_20251029-170644Z.zip.sha256
  - docs/intent/advice/notes/20251029/CoSync_20251029-182512Z.md
- Tag: outreach-seed-20251029

### INBOX_LOG tail (for trace)
| 2025-10-29T18:25:12Z | AdviceBomb | outreach | AdviceBomb_Outreach_CoCivium_20251029-170644Z.zip | SHA256:050beda50d682c7dcf554d06c2d3b8399f91460557c404c9b66f35d5b2b2a184 | by:rick | notes: seed outreach collateral |

## Open items for CoPrime
- CoCache: PR #149 (docs/link-outreach) — merge if still open.
- CoContrib: PR #24 (outreach/pointer) and PR #25 (outreach/seed) — merge after quick check.
- Optionally copy the email templates + handout into CoContrib/outreach (beside pointer README).
- BPOE docs: ensure PasteSafe bullets exist in:
  - CoSteward/docs/ops/MANUAL/05_CI_CD_AND_GUARDS.md
  - CoCivium/docs/bpoe/PS7-Stability.md
- Prep three invite email variants (student, civic-tech, sponsor) for publish under CoContrib/outreach.

## Verification checklist
1. On CoCache main: AdviceBomb ZIP + .sha256 exist; sha256 matches.
2. CoCache README links to seed location.
3. CoContrib has outreach pointer README (and optionally the collateral files).
4. All related PRs merged to main; tag present.

## PasteSafe notes
- Build scripts as array of single-quoted lines -> Set-Content -Encoding utf8NoBOM; run with pwsh -NoProfile.
- Avoid here-strings/backticks; PSReadLine may choke on leading "- " bullets in long pastes.
- Use tiny Safe-Proc wrappers for git/gh when needed (timeouts, clean output).
