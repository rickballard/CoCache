# Risk Register

| ID | Risk | Sev (1-3) | Likelihood (1-3) | Mitigation | Drill / Rollback | Owner | Status |
|----|------|-----------|------------------|------------|------------------|-------|--------|
| R-1 | Repo corruption | 1 | 2 | Read-Only default + snapshot | Rollback bundle restore |  |
| R-2 | Mutex deadlock | 2 | 2 | Timeout + manual override | Simulate lock lost |  |
| R-3 | Spec drift across chats | 2 | 3 | Strict parser + clear errors | Fuzz malformed headers |  |
| R-4 | Data leakage | 1 | 1 | No uploads; generics opt-in | Verify logs scrub |  |
| R-5 | Vendor capture pressure | 1 | 2 | Consent Lock governance | Governance drill |  |
