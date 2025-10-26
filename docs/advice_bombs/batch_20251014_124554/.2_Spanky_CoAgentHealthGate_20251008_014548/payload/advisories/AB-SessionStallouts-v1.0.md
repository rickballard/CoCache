# Advice Bomb: Handling Session Stall-outs & Freezes (v1.0)

## Symptoms
- Output stream freezes; “Try Again” button appears.
- Partial response rendered; retry resumes or restarts.

## Common Causes
- Token/context bloat (oversized requests).
- Safety review pauses (guardrails).
- Network transport hiccups or browser tab throttling.
- Client renderer choking on large code/asset payloads.

## Mitigations (User-facing)
- Retry once; if repeats, **split** the request into smaller chunks.
- Save artifacts before long renders; prefer links over massive inline blobs.
- Keep the tab foreground during long runs; close memory-heavy tabs.

## CoAgent Design Guidance
- **Detect** stall (>10s no tokens) → show “Retry slimmed payload” option.
- **Checkpoint** to repo before heavy outputs (logs/artifacts).
- **Log** stall metadata (payload size, step, time) to run summary.
- **Offer fallback modes**: summarize-first, chunked generation, or low-verbosity render.
- Keep HealthGate/local checks **out of** streamed model responses.

