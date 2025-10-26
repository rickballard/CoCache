# Universal Deep Summary Prompt (Drop-in for Any Session)

Please undertake a thorough analysis of all discussions in this session. Extract main insights, decisions, risks, and next actions. Produce an **Advice Bomb** with:
- `SUMMARY.md` (500–900 words, no fluff)
- `INSIGHTS.md` (bullets: what changed, what matters)
- `ACTION_CHECKLIST.md` (1–2 week tasks)
- `DEPENDENCIES.md` (repos, people, external assets)
- `RISKS.md` (with mitigations)
- `DECISIONS.md` (explicitly record trade-offs)
- `INTENTIONS.md` (what we aim to achieve next)
- `COORDINATION.md` (who/what needs syncing)

Follow CoCivium conventions:
- Use **CoRef IDs** for concepts; **GIBindex** term codes for key terms.
- Keep outputs markdown + JSON only; no binary assets unless requested.
- Assume handoff to CoAgent/CoCache ingestion; include timestamps.
