
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = (Resolve-Path (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "..")).Path
New-Item -ItemType Directory -Force (Join-Path $root "docs") | Out-Null
$stat = @{ auth="linked"; safeguards="PR-first"; undo_hint="gh pr revert <#>"; index="__NOW__"; deliverable="ok" } | ConvertTo-Json -Depth 5
$path = Join-Path $root "docs/status.json"
$stat.Replace("__NOW__", (Get-Date -AsUTC -Format s) + "Z") | Set-Content -Encoding UTF8 $path
Write-Host ("wrote docs/status.json @ {0}" -f ((Get-Date -AsUTC -Format s) + "Z"))
