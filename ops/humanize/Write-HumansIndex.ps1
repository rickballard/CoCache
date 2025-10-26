param([Parameter(Mandatory)][string]$RepoPath)
$ErrorActionPreference='Stop'
Set-Location (Resolve-Path $RepoPath)
New-Item -ItemType Directory -Force -Path .\docs | Out-Null

$body = @"
# Start here (for humans)
Curated entry points:

- **Megascroll** → `docs/cc/scroll/README.md`
- **Canon Index** → `docs/canon/README.md`
- **Insights** → `docs/insights/README.md`
- **Advice Bombs** → `docs/advicebombs/README.md`

_Short, opinionated. The README stays light; HUMANS.md carries the menu._
"@
Set-Content .\docs\HUMANS.md -Value $body -Encoding UTF8
Write-Host "==> DONE: HUMANS.md written" -ForegroundColor Green

