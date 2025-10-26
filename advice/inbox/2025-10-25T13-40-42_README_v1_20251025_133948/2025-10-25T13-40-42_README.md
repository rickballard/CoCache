# Advice Bomb Inbox (CoSuite)

> **FOR AUTOMATED SESSIONS — REQUIRED**
> Treat this README as your prompt. Obey all MUST rules below when dropping or iterating an advice bomb.

## What to drop
- One file: `.md`, `.txt`, or `.json`; or a `.zip` that contains only those types.
- MUST use versioned filenames while iterating, e.g.:
  - `topic-v1.md` -> `topic-v2.md` -> ...
  - Zip example: `topic-v3.zip` (contains only .md/.txt/.json)
- MUST run 2–3 CoEvo loops (self-review/critique/repair) before each new version.
- MUST verify the drop appeared on the repo page after each push:
  https://github.com/rickballard/CoCache/tree/main/advice/inbox

## Guardrails (MUST)
- Max size of current version: <= 256 KB
- Max cadence: <= 1 commit / 30 min
- Max delta per revision: < 20% of file size (favor small, focused changes)
- Auto-finalize after 48h without change (Status: settled)

## Front-matter (put at top of the file)
Title: <short, unique>
Intent: <what should improve>
Owner: <session or handle>
Version: <YYYY-MM-DDThh-mm-ss>
Status: draft | iterating | settled
Guardrails:
  MaxSizeKB: 256
  MaxCadenceMins: 30
  MaxChangePct: 20
Change-Notes:
  - <one line>
  - <one line>

## Ingestion conventions (CoPrime)
- Inbox auto-indexes to docs/intent/advice/index.
- Families are grouped by filename stem (topic-vN -> family topic).
- Older inbox versions may be cleaned after 90 days; all processed versions are archived.
- If your first drop was not versioned, it is treated as v1. Rename to -vN to continue the family.
