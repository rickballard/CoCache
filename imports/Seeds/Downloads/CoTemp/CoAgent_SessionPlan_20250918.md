# CoAgent MVP Session Plan
## Goals
- Safe launcher, backend reachable, UI fallback, background-freeze controls, BPOE breadcrumbs.

## Today / Next
- Sanity log captured (CoSession_Sanity.txt).
- Confirm Safe shortcuts: **PS7 (Safe)**, **CoAgent (Safe Start)**.
- Productize guardrails: boot-delay, cache self-heal, backend retry/local fallback.
- Add "Freeze Background Jobs" UI (wrap Freeze/Thaw scripts).

## MVP Definition
- Reliable cold boot start; PS7 health-gate for shell spawns.
- Local-fallback UI if 127.0.0.1:7681 is down; first-failure cache wipe.
- BPOE breadcrumbs in CoTemp; one-click Freeze/Thaw.

## V2 Parking Lot
- Guardrail telemetry; DISM/SFC helper; AHK v2 keymap module.

## Risks / Mitigations
- Windows Terminal interception (UseTerminal=0 for now).
- IFEO hooks absent; PS profiles quarantined.
