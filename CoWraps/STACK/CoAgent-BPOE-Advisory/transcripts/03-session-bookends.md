# Session Bookends run by CoAgent

## Preflight (before any change)
- Verify shell, repo, branch, hooks path, and clean working tree (or commit boundary).
- Ensure `.gitattributes`, `.editorconfig` present (or stage a patch).
- Ensure pre‑push AB‑bypass marker exists **only** in `.githooks/pre-push.ps1`.
- Run **BPOE Pre‑Sanity (local)**: paste‑safe checks, placeholder bans, disallowed commands in docs.

## Postflight (before PR / deploy)
- Verify `git push` landed and `gh pr create` created a PR.
- Add labels (`BPOE`, `chore`) if missing.
- Ensure GH **BPOE Sanity** workflow exists and is green (presence only).
- Generate concise PR comment with what was auto‑fixed; no sensitive diffs.
