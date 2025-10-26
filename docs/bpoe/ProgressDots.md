# BPOE: Long-Running Steps, Dots, and Session Hygiene

- Use `ops/common/Run-WithDotsEx.ps1` for any step > 3s.
- Dots are **per-second** ".", with a **ten-second** ":" marker and elapsed/predicted pulse.
- Each step prefaces with **“Do not interrupt for ~N s”** and ends with a `[DONE]` stamp.
- Timeouts stop the job and print a clear message (no manual Ctrl+C needed unless requested).
- Prefer SSH remotes for reliability on Windows (`git@github.com:owner/repo.git`).
- Actionlint is enabled for all workflows by default.
- Regroup anytime with `ops/admin/Make-SessionRegroup.ps1` (writes to `admin/sessions/…`).


