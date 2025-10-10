# CoAgent GitHub Multi-Repo Access Strategy (MVP3–MVP4)

## Purpose
Enable CoAgent to access multiple GitHub repos across sessions without re-authentication, using secure and auditable methods.

## Phases
### Phase 1: Local PAT Bootstrapping
- One-time creation of a Personal Access Token (PAT) with `repo`, `admin:org`, and `workflow` scopes.
- Securely store in a local token file (see `Setup-CoAgentToken.ps1`).
- Load the token into CoAgent session environments (`CoAgentTokenLoader.ps1`).

### Phase 2: Token Relay (post-MVP3)
- Use CoCacheGlobal or similar vault to provide session-specific tokens via authenticated requests.
- Tokens stored securely with per-session expiry and revocation options.

### Phase 3: GitHub App Integration
- Replace PAT with GitHub App installed on CoSuite repos.
- CoAgent uses JWT + App ID to generate ephemeral installation tokens.

## Implementation Notes
- No real “child sessions” in ChatGPT unless manually CoWrapped.
- Shell subprocesses (PS7 etc.) **can** be considered child jobs of CoAgent and are bloat-free.
