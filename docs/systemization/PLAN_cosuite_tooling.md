# CoSuite Tooling Systemization — Execution Plan (20251026_155449 UTC)

## Target layout
tools/cosuite/1.0/ps/...
tools/cosuite/1.0/ci/...
tools/cosuite/README.md

## Cut-over steps
1) Move scripts to canonical tree
2) Update CI to reusable files under tools/cosuite/1.0/ci
3) Bulk-repoint all callsites (scripts + CI + docs)
4) Add CI guard denying writes to legacy paths
5) Tag rollback point; open migration PR
