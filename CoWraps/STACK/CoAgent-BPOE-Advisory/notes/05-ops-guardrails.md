# Ops Guardrails (Paste‑Safe)

- Prefer arrays‑of‑lines over here‑strings in console pastes.
- Never include `exit 0` in examples.
- Use ALL_CAPS or `$VARS`, not `<angle>` placeholders in runnable lines.
- Use `-SimpleMatch` for literal text; `-LiteralPath` for file ops.
- AB‑bypass prelude lives only in `.githooks/pre-push.ps1`.
