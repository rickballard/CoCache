# Minimal Hash‑Chain Spec (v0.1)
- Each log line L_i includes: timestamp, actor, action, policy_slot_id, payload_hash, prev_hash.
- prev_hash = SHA256(L_{i-1}); first line seeds from header.
- Rotate daily; write file checksum; optionally anchor externally (timestamp server / public commit).

