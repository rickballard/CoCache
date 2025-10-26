# SDE (Self‑Defensive Evolution) Playbook

States: Idle → Suspicious → Quarantined → Forensics → Hardened.
Triggers: ids_alert, cve_critical, key_anomaly, injection_drift, abnormal_nudge_cadence.
Actions: Quarantine (sandbox/lock), Fence (trust_radius≈0.05), Rollback, KeyRotate, Attest (provenance), Rate‑Limit, Deceive (honeypots).

Authority: SDE can freeze self‑evolution & meta‑tuning. Thaw requires two‑key + attestations.
Logs: tamper‑evident hash chain; evidence packs captured on trigger.
