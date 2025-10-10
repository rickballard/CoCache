param([string]$Name="mvp-smoke",[hashtable]$Data)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
New-Item -ItemType Directory -Force .coagent\logs | Out-Null
$entry = [ordered]@{ ts=(Get-Date).ToString("s"); name=$Name } + $Data
($entry | ConvertTo-Json -Depth 6) + "`n" | Add-Content .coagent\logs\events.jsonl
