# Advice Bomb Inbox (CoSuite)

Drop a single advice bomb (`.md`, `.txt`, `.json`) or a `.zip` containing only those types.
Use **versioned filenames** while iterating, e.g.:
- `coevo-looping-v1.md`, `coevo-looping-v2.md`
- Or zip: `coevo-looping-v3.zip` (contains only .md/.txt/.json)

## CoEvo Looping — working rules
- Max size: **≤ 256 KB**
- Max cadence: **≤ 1 commit / 30 min**
- Max change per revision: **< 20%** of file size
- Auto-finalize after **48h** without change (`Status: settled`)

## Front-matter (put at top)
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

## Examples
- `coevo-looping-v1.md` → `coevo-looping-v2.md`
- `copingpong-habits-v1.md`

> This inbox is auto-indexed to `docs/intent/advice/index`. Older inbox items may be cleaned after 90 days;
> all processed versions are archived with history.
