# Repo Mutex (P0)

Purpose: Prevent concurrent side effects against the same repo path.

Design:
- Name: Global\CoAgentRepo_{SHA1(FullRepoPath)}
- Acquire with 2s timeout (configurable). If busy, back off with jitter; surface 'mutex busy' in logs.
- Release on exit; stale detection: if holder pid not alive or lock older than TTL, allow reclaim with warning.

Acceptance:
- With two writers, only one proceeds at a time.
- No interleaved commits; logs show mutex acquire/release.
