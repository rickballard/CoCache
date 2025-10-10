# BPOE (Best Possible Operational Experience) — Field Guide

**Goals**
- Minimal surprises, visible state, safe defaults, reversible changes.

**Principles**
1. **Clear affordances**: Shortcuts have distinct icons & names.
2. **Predictable boot**: Startup stubs stay silent; visible errors go to logs, not consoles.
3. **Progress feedback**: Spinners + explicit “done/failed” lines.
4. **Reversibility**: Small, logged changes; rollback plan in PR template.
5. **Cross‑shell safety**: Profile hooks gated on PS7 + PSReadLine presence.

**Quick Checks**
- Can a new user recover without context? (stub pages, safe fallbacks)
- Does each script accept `-WhatIf` or dry‑run mode where practical?
- Are logs written to repo (`docs/status/*`) with timestamps?
- Are color features accessible (`-Colorblind` switch)?

**Naming**
- Use verbs for script names: `Start-*`, `Stop-*`, `Repair-*`.
- Use `Write-*` for emitters; use `*Co*` for product-scoped helpers.
