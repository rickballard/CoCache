# Evolution Governance & Autonomy

## Autonomy Ladder
- **L0 Observe** — metrics only
- **L1 Advise** — proposals via PR; human merges
- **L2 Gated Apply** — auto-PR with required checks; human approval
- **L3 Constrained Auto** — auto-merge safe classes (docs/tests/codestyle) post-simulation
- **L4 Episodic Auto** — time-boxed autonomy windows with post-hoc review

## Guardrails (Non-Negotiables)
- Security and data boundaries are blockers
- Public API contracts versioned; stability once marked stable/frozen
- Full lineage and reproducible rollback for every apply
- Consent matrix per repo (what can be exported/ingested)
- Org kill-switch (CoCacheGlobal) for emergency freezes

## Roles
- **CoCache (local steward):** policy hub, orchestrator, lineage, templates
- **CoCacheGlobal (sovereign hub):** heartbeat bus, negotiation/voting, sanctions/veto
- **Product repos:** subjects of evolution, with local fitness contracts

## Decision Flows
- Local/internal changes → L1/L2 path
- Interface-affecting changes → CoCacheGlobal ballot (approval/ranked/quadratic)
- Reputation signals (MeritRank/RepTag) weight votes where enabled

