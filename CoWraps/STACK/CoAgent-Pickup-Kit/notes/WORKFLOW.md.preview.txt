# Workflow & Bloat Controls

**Keep sessions light**
- Rotate to a fresh session when output feels noisy; use CoWrap handoffs.

**Repo discipline**
- Small PRs. Use the included PR template. Fill **Why/What/Verify/Ops**.

**Automation**
- Scheduled CoBreadcrumb tasks write `docs/status/bpoe-log.ndjson` and update TODO index.

**Logs vs. Console**
- User-facing consoles: terse + colored final line.
- Diagnostic detail → logs: `docs/status/*.log`.

**Versioning**
- Tag UX-visible changes (`ux:`), ops helpers (`ops:`), docs (`docs:`).