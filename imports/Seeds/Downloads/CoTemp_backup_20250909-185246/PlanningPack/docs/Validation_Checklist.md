# Validation Checklist (Pre‑Alpha)

## Runtime
- [ ] Exactly one watcher job per session after launcher
- [ ] DO with valid YAML header runs → **pass**; invalid → **rejected**

## Coordination
- [ ] Drops from Planning appear in Migrate inbox and execute
- [ ] Notes show up in the counterpart pane and are archived

## Safety
- [ ] Writes/network disabled unless explicitly allowed in header
- [ ] Logs contain no secrets or PII

## DX
- [ ] New contributor can launch in < 10 minutes
- [ ] Error messages point to fix steps or runbook section
