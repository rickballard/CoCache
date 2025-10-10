# Governance Mandate (P0)

Consent-Lock (cannot change without dual approval):
- Default denies: writes, network, secrets, destructive.
- Change control: dual 75% approvals by Product+Security+Governance reps; public comment window >= 14 days; decision log recorded.
- Vendor-neutral constraint: policy/impl must not force a single vendor.

Emergency override:
- For Sev-1 only, Security Lead + Governance Rep may issue a temporary override (max 72h). Must be logged with rationale and auto-expiry, and reviewed at next triage.

Roles:
- Product: scope and UX safety.
- Security: risk posture, controls, and drills.
- Governance: process integrity, neutrality, audit trail.

Change template:
1) Proposal + diff to policy
2) Impact analysis (risks, users, vendors)
3) Comment window start/end
4) Dual vote outcome (percentages, voters)
5) Effective date and rollback plan
