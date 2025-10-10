# Non-destructive: summarize what actually landed in CoModules (for post-crash sanity)
param([string]$Repo = "$HOME\Documents\GitHub\CoModules")
$ErrorActionPreference='SilentlyContinue'
if(-not (Test-Path $Repo)){ Write-Host "[CoRepo-Audit] Repo not found: $Repo" -ForegroundColor Yellow; exit 0 }
Push-Location $Repo
try {
  $branch = (git branch --show-current).Trim()
  Write-Host ("Branch: {0}" -f $branch) -ForegroundColor Cyan

  Write-Host "`n--- status ---" -ForegroundColor Yellow
  git status --porcelain=v1

  Write-Host "`n--- recent commits (2h) ---" -ForegroundColor Yellow
  git log --since="2 hours ago" --oneline --decorate

  $expected = @(
    'tools/Test-BPOE.ps1',
    'tools/BPOE/CoTint.psm1',
    'tools/BPOE/CoCache.psm1',
    'docs/methods/BPOE_ISSUEOPS_Explainer.md',
    'docs/methods/BPOE_Preflight.md',
    'docs/methods/BPOE_Color_Policy.md',
    'docs/methods/BPOE_SESSION_CARD.md',
    'tests/BPOE.CoPong.Tests.ps1',
    'tests/BPOE.Heartbeat.Tests.ps1',
    'tests/BPOE.CoCache.Tests.ps1'
  )

  Write-Host "`n--- expected artifacts present? ---" -ForegroundColor Yellow
  $expected | ForEach-Object {
    $p = $_
    $status = if (Test-Path $p) { 'OK' } else { 'MISSING' }
    '{0,-48} {1}' -f $p, $status
  }

  Write-Host "`n--- non-empty sizes ---" -ForegroundColor Yellow
  $expected | Where-Object { Test-Path $_ } | ForEach-Object {
    $len = (Get-Item $_).Length
    '{0,-48} {1} bytes' -f $_, $len
  }
} finally { Pop-Location }