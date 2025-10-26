# CoAgent — Near-Term Advice (MVP3 window)

**Implementable next:**  
- **Log format:** JSONL with fields: timestamp, actor, action, policy_slot_id, payload_hash, prev_hash; rotate daily; file checksum; optional external anchor.  
- **Metrics:** Auditability coverage (≥95%), median time‑to‑trace (≤90s), drift false‑positive (≤2%).  
- **Viewer:** minimal log viewer that jumps from output → decision path → policy slot; copy hash.

**Anti‑capture posture:**  
- Public spec; test fixtures; export logs in vendor‑neutral schemas; forbid opaque “explainability” that cannot be verified.
