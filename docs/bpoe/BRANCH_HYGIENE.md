# BPOE: Branch Hygiene

Classes:
  - KEEP: open/draft PR or active
  - REWRITE: contains >=100MB blob(s) or touches known heavy paths
  - ARCHIVE: merged to default, or stale and no unique commits

Use your branch-audit script to emit CSV/JSON, then:
  - tag backup/* before deletes
  - optionally create .bundle snapshots
  - delete local branch (and remote ref if desired; deletes aren’t blocked)

