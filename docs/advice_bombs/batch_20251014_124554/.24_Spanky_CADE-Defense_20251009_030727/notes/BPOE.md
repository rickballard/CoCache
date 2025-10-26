# BPOE Notes — Defense & Hygiene Additions
1) **Adversary-Resistant Posture (authoritarian-state threat model):**
   - Backups: daily encrypted off-platform; weekly offline; integrity checks.
   - Auto-restore triggers on tripwires; audited.
   - Redundancy: Git mirrors (GitLab/Codeberg/IPFS), static fallbacks; DNS/registrar redundancy.
   - Defense with humor & humane re-alignment outreach.

2) **CoAgent Model Selection Control:**
   - CoAgent chooses per-session/model; provider auto-switching disabled by policy.
   - Capability/cost/safety-driven routing; pluggable backends.

3) **Session Hygiene (8–20h max):**
   - Rotate proactively; export CoWrap; update CoCache on rollover.

4) **Browser Cache Corruption Mitigation:**
   - Offer opt-in cache-health check; one-click reset flow; keep secrets out of cache.

5) **Heavy Session UX & Heartbeat:**
   - Watchdog heartbeats; visible progress.
   - If stall: safe refresh guidance or minimal prompt nudge; recover buffers.

