# Strategy: Keep BPOE inside CoAgent

**Why not “just put it in GitHub”?**
- Vendor CI and logs are discoverable by that vendor. Even when private, assume metadata/telemetry may be processed.
- We want reproducible, user‑controllable behavior across vendors and sessions. That means **CoAgent is the orchestrator**.

**Principles**
1. **Own the heuristics.** All nontrivial checks (e.g., paste‑safety inference, content lint rules, advisory generation) run in CoAgent, locally or in our controlled infra.
2. **Enforce at the edge.** GitHub enforces *that* guards exist (markers, file presence, branch protection), not *how* they pass.
3. **Minimize leakage.** CI prints only pass/fail and filenames — never the content of matched lines; keep retention short.
4. **Externalized memory (ADR‑0003).** CoAgent preloads BPOE norms on session start and persists state to repos/sidecars, not to vendor memory.
