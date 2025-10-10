# CoAgent — Product Roadmap
_Updated 2025-09-14T05:21:37Z_

## Why
CoAgent is the **accountable, policy-aware agent** for CoCivium tasks: evidence in, transparent actions out; human-in-the-loop by design.

## Tenets (product)
- **Consent-first** actions; reversible by default
- **Provenance** for every step (who/why/when/inputs)
- **Policy runtime** (org/sector/locale) pluggable
- **Interop** via open protocols (CoCivium/CoModules)
- **Agent observability** (traces, audits, replay)

## Now → Next → Later
**Now (0–6 weeks)**  
- v0.1 *Local Runner*: task graph, adapters (FS/HTTP), minimal policy checks, trace log  
- DevEx: Docker image, quickstart, sample tasks

**Next (6–12 weeks)**  
- v0.2 *Policy & Identity*: policy engine (OPA-style), API keys/secrets vault, role contexts  
- v0.2.1 Observability bundle: structured traces, replay CLI

**Later (12+ weeks)**  
- v0.3 *Multi-agent & Delegation*: supervisor/worker topology, quotas, rate limits  
- v0.4 *Marketplace & Modules*: signed modules, capability descriptors  
- v1.0 *Stable*: long-term support, security hardening, conformance suite

## Release Train (targets)
| Version | Window | Goals |
|---|---|---|
| v0.1 | Wk 0–6 | Local Runner, basic adapters, trace log |
| v0.2 | Wk 6–12 | Policy engine, identity/roles, vault |
| v0.3 | Q+1 | Multi-agent, supervisor/worker, quotas |
| v0.4 | Q+2 | Module signing, capability registry |
| v1.0 | GA | Hardening, conformance, support policy |

## Metrics
Activation (QS success), Weekly Active Agents, Task success %, Mean task latency, Policy violation rate, Replay fidelity.

## Risks & Mitigations
Scope creep → roadmap guardrails; policy complexity → staged adapters; security → keys-in-vault, signed modules, CI scans.

## Dependencies
- CoCache: BEACON + scrolls (principles)
- CoModules: adapters, signed manifests
- Infra: Docker + minimal K8s, OPA-compatible policy

---
**Canonicality**: Level 3 (Managed). Reviews quarterly.
