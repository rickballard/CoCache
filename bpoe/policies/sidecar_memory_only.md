# Policy: Sidecar Memory Only (CoCache as source of truth)

**Rule:** Do not store durable workflow preferences, habits, or session state in ChatGPT’s built-in “memory”.
**Always** persist intersessional context in the **CoCache** repo (documents, advice bombs, status lines, handoffs).

**Rationale**
- Reproducibility & diffability (git).
- Team visibility & portability across agents/tools.
- Avoids opaque retention/eviction behavior of app memory.

**Operational Checklist**
- [ ] Update `docs/bpoe-status.md` in-session.
- [ ] Drop CoTemp markers/heartbeats locally.
- [ ] Land AdviceBombs/IdeaCards under `insights/` or `docs/`.
- [ ] CoWrap before closing or on BloatSignal.
