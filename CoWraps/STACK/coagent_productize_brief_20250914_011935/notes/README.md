# CoAgent Productize Brief
_Date: 2025-09-14 01:19:35Z_

This bundle summarizes observations and requirements from the **Grand Migration** session to help the **Productize CoAgent** track.

## TL;DR
- **Avoid focus steals**: On boot, PS7 popups (`Launch Profile`, `CoAgent Migrate`, `CoAgent Planning`) appeared and grabbed focus, interrupting typing with a blank flicker popup. Stealth by default.
- **Default ephemeral**: CoAgent should be **on-demand** by default; resident mode only with explicit consent and clear terms.
- **Only surface on repo-context**: Background services must be quiet; no UI unless a repo action is implied.
- **Device-local profile location**: Any persistent profile/log should live in `~/Downloads/CoTemp/Profile`, visible and deletable.
- **Grand Migration has priority**: Other sessions observe and leave breadcrumbs/advice; do not take actions that affect repos.
- **CoTemp inter-session channel**: Use **top-level** `~/Downloads/CoTemp/inbox/*.json` (no subfolders). Watchers filter by `to` tag and write acks to `~/Downloads/CoTemp/Logs`.

## In this bundle
- `scripts/Start-CoInboxWatcher.ps1` — quiet FileSystemWatcher that filters by `to` tag and writes acks.
- `scripts/Add-WatcherToProfile.ps1` — optional; appends a one-liner to start watchers at shell launch.
- `schemas/cotemp_inbox_example.json` — canonical example for messages in `CoTemp\inbox`.
- `notes/productize_note_example.json` — example “productize” note mirroring what was dropped.
- `notes/profile_note_example.json` — example “profile” note mirroring what was dropped.
- `brief/What-We-Did.md` — concise narrative of actions taken and outcomes.
- `bpoe/UX-Demark-Guideline.md` — “CoPong Demark” guideline (2 blank lines + colored rule + 2 blank lines).

## Quick start (Productize PS7 pane)
```powershell
# 1) Unzip somewhere (e.g., ~/Downloads/CoTemp/Drops/ProductizeBrief)
# 2) Start a watcher for the 'prod' tag (top-level inbox; quiet)
. "$PSScriptRoot/scripts/Start-CoInboxWatcher.ps1"
Start-CoInboxWatcher -Inbox "$HOME\Downloads\CoTemp\inbox" -ToTag 'prod'

# optional: auto-start watcher from profile
. "$PSScriptRoot/scripts/Add-WatcherToProfile.ps1"
Add-WatcherToProfile -ToTag 'prod'
```

## Action items for Productization
1. **Stealth startup**: Audit any scheduled tasks or profile hooks that raise PS7 windows; switch to hidden/quiet launch.
2. **Consent & disclosures**: Implement explicit opt-in for resident mode; show clear terms about behavior and stored data.
3. **Pairing stability**: Keep PS7 panes ↔ chat tabs consistent without force-raising windows; store pairing data in `CoTemp/Pairings`.
4. **CoTemp protocol**: Standardize top-level `inbox/*.json`, write acks, and backoff polling. Never interrupt typing.
5. **Naming**: Normalize to “CoCivium” outside the internal repo naming.
6. **Breadcrumbs-first**: Other sessions should capture advice in CoTemp and repo docs (`docs/index/*`) rather than taking actions.
