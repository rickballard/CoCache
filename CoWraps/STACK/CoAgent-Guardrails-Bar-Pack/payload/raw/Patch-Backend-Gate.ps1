[CmdletBinding()]
param([string]$RepoPath="$HOME\Documents\GitHub\CoAgent")
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
function Info($m){ Write-Host "[INFO] $m" }
function Die($m){ throw "[FATAL] $m" }

$repo = Resolve-Path $RepoPath -ErrorAction SilentlyContinue
if (-not $repo) { Die "Repo not found: $RepoPath" }

$mainCandidates = @(
  "electron\main.js","electron\src\main.js","electron\src\main.ts","electron\main.ts"
) | ForEach-Object { Join-Path $repo $_ } | Where-Object { Test-Path $_ }

if (-not $mainCandidates) { Die "Electron main not found (tried electron\\main(.js|.ts) and electron\\src\\main)." }
$patched = 0
foreach($main in $mainCandidates){
  $raw = Get-Content -Raw $main
  if ($raw -match "127\.0\.0\.1:7681" -and $raw -notmatch "BACKEND_GATE_INSERTED") {
    Copy-Item $main "$main.bak" -Force
    $snippet = @"
(async () => {
  // BACKEND_GATE_INSERTED
  try {
    await win.loadURL('http://127.0.0.1:7681/');
  } catch (e) {
    const {join} = require('path');
    const {existsSync} = require('fs');
    const local = [
      join(__dirname, 'index.html'),
      join(process.cwd(), 'electron', 'index.html'),
      join(process.cwd(), 'electron', 'public', 'index.html')
    ].find(existsSync);
    if (local) { await win.loadFile(local); } else { throw e; }
  }
})()
"@
    $raw = $raw -replace "win\.loadURL\([^\)]*127\.0\.0\.1:7681[^\)]*\)", $snippet
    Set-Content -Encoding UTF8 $main $raw
    Info "Patched backend gate in: $main (backup at $main.bak)"
    $patched++
  }
}
if ($patched -gt 0 -and (Test-Path (Join-Path $repo '.git'))) {
  Push-Location $repo
  try { git add -A; if (-not (git diff --cached --quiet)) { git commit -m "fix(electron): backend gate with local fallback when 7681 down" } } finally { Pop-Location }
}
