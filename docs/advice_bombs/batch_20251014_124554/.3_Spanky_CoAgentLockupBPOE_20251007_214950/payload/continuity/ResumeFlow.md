# Continuity: Resume Flow After Lockup
**Goal:** Zero data loss + fast return to flow.

## Protocol
1. Auto-save working state to CoCache every N minutes and on error signals.
2. Provide "Resume in Fresh Session" button (opens clean context, reattaches state).
3. Persist minimal `out.txt` status line for human audit.
4. Post-mortem bundle (logs, steps) into the Spanky CoWrap when requested.

