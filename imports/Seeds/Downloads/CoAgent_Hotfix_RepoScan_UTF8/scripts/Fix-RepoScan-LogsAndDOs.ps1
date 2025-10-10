Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null

function Get-RepoPathFromHeader {
  param([string]$Text)
  $m = [regex]::Match($Text, 'repo:\s*\{\s*name:\s*".*?",\s*path:\s*"(?<p>[^"]+)"\s*\}', 'IgnoreCase')
  if ($m.Success) { return $m.Groups['p'].Value }
  return (Join-Path $HOME 'Desktop\CoAgent_SandboxRepo')
}

$targets = @()
$targets += Get-ChildItem (Join-Path $root 'sessions\co-migrate\inbox')  -Filter 'DO*_RepoScan*ReadOnly*.ps1' -ErrorAction SilentlyContinue
$targets += Get-ChildItem (Join-Path $root 'sessions\co-migrate\outbox') -Filter 'DO*_RepoScan*ReadOnly*.ps1' -ErrorAction SilentlyContinue

foreach($f in ($targets | Sort-Object LastWriteTime -Descending)){
  try {
    $t = Get-Content -Raw -LiteralPath $f.FullName
    $repo = Get-RepoPathFromHeader -Text $t
    $session = $env:COSESSION_ID; if (-not $session) { $session = 'co-migrate' }

    $safe = @'
<# ---
title: "DO-RepoScan-ReadOnly"
session_id: "{0}"
repo: { name: "Sandbox", path: "{1}" }
risk: { writes: false, network: false, secrets: false, destructive: false }
brief: "List up to 50 files with size and last write time; read-only."
consent: { allow_writes: false, allow_network: false }
--- #>
# [PASTE IN POWERSHELL]
"repo-scan-readonly at $(Get-Date -Format o) - {1}"
Get-ChildItem -LiteralPath "{1}" -Recurse -File -ErrorAction SilentlyContinue |
  Select-Object FullName, Length, LastWriteTime -First 50
$PSVersionTable.PSVersion
'@ -f $session, $repo

    Set-Content -LiteralPath $f.FullName -Value $safe -Encoding UTF8
    Write-Host ("Rewrote: {0}" -f $f.FullName) -ForegroundColor Yellow
  } catch {
    Write-Warning ("Skip (error): {0} -> {1}" -f $f.FullName, $_.Exception.Message)
  }
}

Write-Host "Done. Re-queue a fresh read-only scan if needed:" -ForegroundColor Cyan
Write-Host "& `"$HOME\Downloads\CoAgent_Hotfix_RepoScan_UTF8\scripts\New-DO-RepoScan-ReadOnly.ps1`""
