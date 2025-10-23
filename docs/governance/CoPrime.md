# CoPrime — Session Coordination Role (GIBindex term)

**CoPrime**: the session temporarily responsible for arbitration of specific repo(s) and/or subordinate session(s).
Duties:
- Publish **intent** + **progress** receipts (CoSync JSONL) per sweep.
- Enforce freeze windows and hygiene in-scope repos.
- Require subordinate sessions to surface their intent/progress on-repo.
- Use **CoReflex** (Reflex) to detect divergence/duplication early (fast/local fail-safe).
- Prefer PRs for scoped paths; “[HOLD] — respect-freeze” when freezes apply; squash-merge; no force-push.

Artifacts:
- `status/notices/*` — freezes / coordination notices.
- `status/governance/coprime_roster.json` — who is CoPrime over what, and until when.
- `docs/intent/manifest.json` — registered Reflex packages (asset+version).
