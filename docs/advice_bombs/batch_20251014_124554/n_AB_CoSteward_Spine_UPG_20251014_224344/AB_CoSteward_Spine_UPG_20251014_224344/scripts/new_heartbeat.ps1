Param([switch]$Weekly)
$today = (Get-Date).ToString('yyyy-MM-dd')
$tz = 'America/Toronto'
$dir = Join-Path $PSScriptRoot "..\heartbeats"
New-Item -ItemType Directory -Force -Path $dir | Out-Null
$file = Join-Path $dir "$today.md"
if(Test-Path $file){ Write-Host "Heartbeat exists: $file"; exit 0 }
@"
# $(if($Weekly){"Weekly"}else{"Daily"}) Heartbeat — $today ($tz)

## coagent-mvp3
- Shipped delta:
- Next commit:
- Risk:

## cocore-v0.2
- Shipped delta:
- Next commit:
- Risk:

## proof-object-1
- Shipped delta:
- Next commit:
- Risk:
"@ | Set-Content $file -Encoding UTF8
Write-Host "Wrote $file"

