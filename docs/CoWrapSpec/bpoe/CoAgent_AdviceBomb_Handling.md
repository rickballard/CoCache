# CoAgent BPOE: Advice Bomb Handling Policy v1.0

Advice Bombs are high-potential action payloads. If activated blindly, they may trigger major change.

## Safety Handling Protocol

1. **Do not auto-execute.**
2. **Parse the `run.ps1` dry-run style first.**
3. Load metadata from `*_manifest.json` or embedded `CoWrap` log.
4. Validate whether human confirmation is required.
5. Log all outputs if run in sandbox mode.

## Default Behavior (Recommended)
> `CoAgent` should default to **dryrun=true** unless explicitly told otherwise by HumanGate or pre-approved CoWrap signature.
