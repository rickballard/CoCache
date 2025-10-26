# GOVERNANCE_PLAN.md

## Core Constraints

1. **Humangate**: Rate limits on iteration frequency and scope expansion based on human review thresholds.
2. **Loop Pacing**: Enforced cooldown periods between AdviceBomb generations.
3. **Drift Dampening**: Use `GIBpulse.json` to detect conceptual divergence beyond threshold.
4. **Anchor Checks**: Require referential alignment to CoRef and CoNeura trees every N iterations.

## Implementation Methods

- `loop_manifest.yaml`: Used to track live loops, actors, roles, TTLs.
- `watcher-CoEvo.ps1`: Local repo watcher for CoEvo loop heartbeat.
- `CoSign-AI.ps1`: Loop checkpointing with witness signatures.

