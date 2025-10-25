# Advice Bomb Inbox (CoSuite)

Drop a single advice bomb (`.md`, `.txt`, `.json`) or a `.zip` containing only those types.
Reuse the **same filename** when iterating — each change becomes a new version.

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
- `coevo-looping.md` (iterative)
- `copingpong-habits.md` (static guidance)

> This inbox is auto-indexed to `docs/intent/advice/index`. Older inbox items may be cleaned after 90 days;
> all processed versions are archived with history.
