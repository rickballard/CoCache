title: "DO-hello-world"
session_id: "chat-local"
repo.name: "none"
repo.path: ""
risk.writes: false
risk.network: false
risk.secrets: false
risk.destructive: false
est_runtime: "PT5S"
requires: ["ps7>=7.5"]
brief: "Print hello and PS version."
effects.files_touched: []
effects.services_touched: []
rollback: "none"
outputs.logs: true
outputs.artifacts: []
consent.allow_writes: false
consent.allow_network: false
sign.alg: "none"
sign.by: "CompanionGPT"

[PASTE IN POWERSHELL]
''|Out-Null
Write-Host "Hello from CoAgent DO"
$PSVersionTable.PSVersion
''|Out-Null
