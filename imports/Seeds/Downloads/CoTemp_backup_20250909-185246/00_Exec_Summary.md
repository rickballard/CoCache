# CoAgent – Executive Summary (One-Pager)

**Problem**: Teams need reliable, policy-driven *multi-model* AI that cross-checks outputs, reaches consensus,
and logs provenance—without vendor lock-in.

**Solution**: CoAgent orchestrates multiple models, constrains them with policies, and aggregates answers
with adjudication/consensus. It provides logs, budgets, and guardrails. Pre-CoAgent mode uses CoTemp to
coordinate sessions; full CoAgent integrates directly.

**Why now**: Model quality varies across vendors/tasks; regulation and reliability expectations are rising.

**Initial ICP**: (e.g., data/ops teams, compliance-heavy orgs, RAG-heavy apps.)

**Differentiation**: Vendor-agnostic consensus layer, transparent provenance, safety controls, predictable costs.

**MVP outline**: Fan-out → normalize → judge/majority → constraint checks → provenance log.

**Go-to-market**: Design-partner program + self-serve CE; integrations with popular repos/IDEs/issue trackers.

**Key risks & mitigations**: see `02_RATs_Assumptions_Test_Plan.md`.
