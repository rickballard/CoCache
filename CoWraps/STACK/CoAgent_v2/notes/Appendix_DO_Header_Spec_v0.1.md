# DO Header Spec v0.1

CoAgent executes only DO files that include structured front-matter. This is the contract between ChatGPT (or any LLM), humans, and CoAgent.

## YAML Front-Matter (required)

title: "DO-hello-world"
session_id: "chat-xyz789"      # ties CoPong back to the chat (optional)
repo.name: "none"
repo.path: ""
risk.writes: false             # set true only if DO must write
risk.network: false
risk.secrets: false
risk.destructive: false
est_runtime: "PT5S"            # ISO 8601 duration
requires: ["ps7>=7.5"]
brief: "Print hello and PS version."
effects.files_touched: []      # list explicit paths when writes=true
effects.services_touched: []   # e.g., github.com/api, localhost:3000
rollback: "none"               # or worktree_snapshot | custom
outputs.logs: true
outputs.artifacts: []
consent.allow_writes: false
consent.allow_network: false
sign.alg: "none"
sign.by: "CompanionGPT"

## Body blocks CoAgent will accept

Each PowerShell block must be preceded by a single line that says:
[PASTE IN POWERSHELL]

Then the block itself is raw PS code (no markdown fences). Example:

[PASTE IN POWERSHELL]
''|Out-Null
Write-Host "Hello from CoAgent DO"
$PSVersionTable.PSVersion
''|Out-Null

## Machine-checkable rules (summary)

- All front-matter keys must be present; booleans explicit.
- If risk.writes = true → effects.files_touched must be non-empty and user must consent.
- If risk.network = true → effects.services_touched must be non-empty and user must consent.
- Any risk=true strongly recommends rollback ≠ "none".
- Only blocks with the exact marker [PASTE IN POWERSHELL] are runnable; others are ignored.
