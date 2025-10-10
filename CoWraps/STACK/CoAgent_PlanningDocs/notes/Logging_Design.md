# Per-run Logging (P0)

Files per run:
- log.txt: human-readable timeline
- log.json: structured events

log.json schema (minimum):
{
  'ts': '<ISO8601>',
  'session_id': '<guid or pid-timestamp>',
  'do_title': '<string>',
  'repo_path': '<string>',
  'risk': { 'writes': bool, 'network': bool, 'secrets': bool, 'destructive': bool },
  'consent_effective': { 'allow_writes': bool, 'allow_network': bool },
  'events': [ { 'ts':'...', 'type':'info|warn|error', 'op':'acquire-mutex|run|rollback|net', 'msg':'...', 'elapsed_ms':123 } ],
  'result': 'pass|fail'
}

Rules:
- No secrets or tokens in logs.
- Append-only; rotate by date; keep 30 days.
