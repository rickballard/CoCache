# Coordination Model (Pre‑CoAgent)

- **Panel registry**: JSON per PS process, maps {name, session_id, inbox/outbox/logs}.
- **Watcher**: one per session; stable‑file check; runs DO; writes txt + json logs.
- **Bridge**:
  - `Drop-CoDO -To <target> -Body <script>` → runnable work
  - `Send-CoNote -ToSessionId <id> -Text <msg>` → human note

**Invariant**: Max one watcher per session.
