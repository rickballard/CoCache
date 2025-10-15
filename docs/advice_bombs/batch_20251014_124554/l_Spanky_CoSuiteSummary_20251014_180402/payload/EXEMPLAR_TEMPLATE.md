--- 
id: "EX-{{YYYY}}-{{NNNN}}"
slug: "{{SLUG}}"
title: "{{TITLE}}"
version: "0.1.0"
status: "concept"
domain: "{{DOMAIN}}"
subdomain: "{{SUBDOMAIN}}"
jurisdictions: ["global-generic"]
created: "{{CREATED_ISO}}"
updated: "{{UPDATED_ISO}}"
license: "CC BY 4.0"
provenance: {authors: [], organizations: [], funding: [], conflicts_of_interest: ""}
attestation: {submitter: "", contact: "", statement: "Accurate to the best of my knowledge."}
readiness: {evidence_grade: "U", risk_profile: ["med"], ethical_flags: [], legal_constraints: []}
review: {humangate_required: true, reviewers: [], notes: ""}
comparability_class: "Access"
denominator: "per_case"
baseline: {}
effect_model: "BeforeAfter"
uncertainty: {}
equity_breakouts: ["age","income","rural_urban"]
rights_burden_index: 50
feasibility_index: 50
reversibility_score: 70
version_semver: "0.1.0"
stability_state: "emergent"
flags: []
kpis:
  - id: "KPI-G-01"
    name: "Service access time"
    definition: "Median days to access service"
    unit: "days"
    direction: "down_is_better"
    collection_method: "admin data"
    refresh_cadence: "quarterly"
    source_dataset_id: "DATA-G-ACCESS-01"
    equity_breakouts: ["age","income","rural_urban"]
    normalization: {denominator: "per_case", transform: "none"}
    quality_grade: "C"
---
# 1. Snapshot
# 2. Problem
# 3. Approach
# 4. Evidence & Risks
# 5. Implementation Hints
# 6. Standards & Mappings
# 7. Governance & Ethics
