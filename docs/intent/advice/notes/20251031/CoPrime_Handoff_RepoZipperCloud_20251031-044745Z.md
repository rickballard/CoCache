# Handoff: RepoZipper Cloud (RC1)

**Status:** RC1 live with read-only guarantees; release assets + trust docs in repo.

## What exists
- Tools: \	ools/RepoZipper_Cloud.ps1\, \	ools/LocalRepoJanitor.ps1\
- Docs: README (verify read-only), TRUST.md, SECURITY.md, CONTRIBUTING.md, CODE_OF_CONDUCT.md
- CI: markdownlint badge + workflow
- Release: v0.9.0-rc1 (ZIP + SHA256)

## What to do (CoPrime)
1) Announce RC in RickPublic & CoContrib (newcomer quickstart).
2) Open “Call for testers” issue; label \help-wanted\.
3) Draft GitHub Action “RepoZipper Cloud (scheduler)” **design** (read-only preview; no pushes).
4) Optional packaging outline: winget/homebrew; keep “no telemetry” explicit.
5) Maintain TRUST stance = **no pushes / no telemetry / local-only** (documented).

## Guardrails
- Never push; never write to remote. Secrets never exfiltrated.
- Account Snapshot lists **names only**; optional & local-only.

## Links
- Repo: https://github.com/rickballard/CoSuiteBackup
- Release: https://github.com/rickballard/CoSuiteBackup/releases/tag/v0.9.0-rc1
- TRUST: ./TRUST.md