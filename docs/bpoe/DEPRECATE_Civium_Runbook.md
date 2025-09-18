---
runbook: Deprecate Civium (private + archived)
repo: rickballard/CoCivium
created_local: 2025-09-18T23:11:36Z
version: v1
---

# Civium Deprecation Runbook

> Goal: make **CoCivium** private and archived, with backups and clear pointers.

## 0) Preflight (local)
- [ ] Create full backup bundle:
      `git bundle create ../cocivium-pre-deprecate-$(Get-Date -Format yyyyMMddHHmmss).bundle --all`
- [ ] Verify no blobs ≥100MB remain (post-rewrite gate).
- [ ] Tag current default branch: `git tag -a final-public -m "Final public snapshot"`

## 1) Freeze activity
- [ ] Close/merge outstanding PRs or leave a notice.
- [ ] Protect default branch (no pushes) or lock it temporarily.

## 2) Deprecation README (last public commit)
- [ ] Replace README with a short deprecation notice pointing to active repos/CoCache (commit as last public change).

## 3) Make private and archive (requires maintainer perms)
```powershell
gh repo edit rickballard/CoCivium --visibility private
gh repo archive rickballard/CoCivium --confirm
# Rebuild $DEPRECATE cleanly (no ``` fences so it's less fragile)
$DEPRECATE = @'
---
runbook: Deprecate Civium (private + archived)
repo: rickballard/CoCivium
created_local: 2025-09-18T23:11:36Z
version: v1
---

# Civium Deprecation Runbook

> Goal: make **CoCivium** private and archived, with backups and clear pointers.

## 0) Preflight (local)
- [ ] Create full backup bundle:
      git bundle create ../cocivium-pre-deprecate-$(Get-Date -Format yyyyMMddHHmmss).bundle --all
- [ ] Verify no blobs ≥100MB remain (post-rewrite gate).
- [ ] Tag current default branch:
      git tag -a final-public -m "Final public snapshot"

## 1) Freeze activity
- [ ] Close/merge outstanding PRs or leave a notice.
- [ ] Protect default branch (no pushes) or lock it temporarily.

## 2) Deprecation README (last public commit)
- [ ] Replace README with a short deprecation notice pointing to active repos/CoCache (commit as last public change).

## 3) Make private and archive (requires maintainer perms)
    gh repo edit rickballard/CoCivium --visibility private
    gh repo archive rickballard/CoCivium --confirm

## 4) Disable CI / housekeeping
- [ ] Disable Actions, Pages, and webhooks if any.
- [ ] Update CoCache docs that referenced CoCivium.
- [ ] Add a pointer doc in CoCache: docs/migration/Civium-Archived.md

## 5) Rollback (if needed)
    gh repo unarchive rickballard/CoCivium --confirm
    gh repo edit rickballard/CoCivium --visibility public

## 6) Communicate
- [ ] Drop advisory to Productization & Sweep sessions via CoTemp.
