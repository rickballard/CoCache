# BPOE (Best Practices, Operationalized & Enforced)
- Close here-strings on their own lines.
- Encoding on the writer (e.g., Set-Content -Encoding UTF8).
- Deterministic outputs: same input → same output.
- No silent failures: $ErrorActionPreference='Stop', Set-StrictMode -Version Latest.
- Visible automation & logs for auditability.


