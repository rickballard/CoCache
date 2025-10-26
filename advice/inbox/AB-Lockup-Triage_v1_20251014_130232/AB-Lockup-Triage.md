# Advice Bomb: Lockup Triage (CoAgent)
**Intent:** Provide a deterministic drill when UI sessions freeze or refuse to load.

## Drill (Run in Order)
1. **Browser reset:** Open a *private/incognito* window; if fixed, clear cookies/cache for chat.openai.com and your CoAgent host.
2. **Disable extensions:** Retry with all browser extensions off (or use a clean secondary browser).
3. **Device swap:** Try from a different device (phone/tablet). If it works there, the issue is local to your machine/browser.
4. **System restart:** Reboot to clear resource exhaustion and zombie processes.
5. **Service health:** Check OpenAI/LLM provider status and rate limits.
6. **CoAgent overlays:** Pause watchers/loggers/sidecars; resume one-by-one to isolate interference.
7. **Escalate:** If all fail, file a repo issue with timestamps, console logs, and steps tried.

## Evidence → Decision
- Consistent failure across devices ⇒ upstream/service-side.
- Works in alt browser ⇒ extension/corrupt profile.
- Works after reboot ⇒ resource/zombie process.

## Output Artifacts
- `continuity/ResumeFlow.md` protocol
- HealthGate preflight checks
