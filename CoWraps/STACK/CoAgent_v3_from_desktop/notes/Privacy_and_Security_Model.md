# Privacy & Security Model

**Local-first**: All execution local. No cloud required.

**Data Sharing (opt-in)**
- Only anonymized generics; never raw org/user data
- Explicit prompts per export; policy: Never / Ask / Auto (per type)

**Guards**
- Read-Only default; --allow-writes per run
- Network Guard (deny by default)
- Secret scrubbing in logs
- Signed binaries and updates; integrity checks

**Compliance**
- Least privilege; immutable logs; optional enterprise audit vault
