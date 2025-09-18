# BloatSignal: AutoLimitBanner

**Trigger:** ChatGPT UI shows "You've reached your limit for scheduled tasks..."
**Risk:** HIGH (session likely bloated/compromised; lag usually follows)

**Required Actions**
1. Stop creating automations in this session.
2. Update BPOE status: `Compromised?=Y (AutoLimitBanner)`.
3. Create local CoTemp marker: `BLOAT_AutoLimitBanner.txt`.
4. CoWrap and restart in a fresh session.
5. Log event here with timestamp + session tag.
6. In next session, avoid scheduled tasks; batch if unavoidable.

**Observed behavior:** Clearing/pausing tasks rarely clears the banner quickly; treat as persistent fault flag.

- Event: 2025-09-18 19:23:05-04:00  SessionTag: co-migrate  Outcome: Marked compromised; CoWrap initiated.

