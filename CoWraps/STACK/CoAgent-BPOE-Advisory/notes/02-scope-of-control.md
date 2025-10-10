# Scope of Control

| Area | CoAgent (Own) | GitHub (Enforce) |
|---|---|---|
| BPOE heuristics & rules | ✅ | ❌ |
| Session preflight/postflight | ✅ | ❌ |
| Secrets, tokens, memory preload | ✅ | ❌ |
| Branch protection/required checks | Orchestrate | ✅ (vendor feature) |
| Minimal guard checks (markers/no `<branch>`) | ❌ | ✅ (non-sensitive presence checks only) |
| Logs & telemetry | ✅ (local structured) | Minimized (pass/fail) |
