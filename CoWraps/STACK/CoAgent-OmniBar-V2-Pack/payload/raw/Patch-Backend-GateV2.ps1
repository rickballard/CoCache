[CmdletBinding()]
param([string]$RepoPath="$HOME\Documents\GitHub\CoAgent")
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
function Info($m){ Write-Host "[INFO] $m" }
function Die($m){ throw "[FATAL] $m" }

$repo = Resolve-Path $RepoPath -ErrorAction SilentlyContinue
if (-not $repo) { Die "Repo not found: $RepoPath" }

$mainCandidates = @(
  "electron\main.js","electron\src\main.js","electron\src\main.ts","electron\main.ts","electron\app\main.js","electron\app\main.ts"
) | ForEach-Object { Join-Path $repo $_ } | Where-Object { Test-Path $_ }
if (-not $mainCandidates) { Die "Electron main not found." }

$patched = 0
foreach($main in $mainCandidates){
  $raw = Get-Content -Raw $main
  if ($raw -match "127\.0\.0\.1:7681") {
    # Replace direct loadURL call
    $snippet = @"
async function loadCoAgent(win) {
  try {
    // prefer real backend if reachable
    await fetch('http://127.0.0.1:7681/', {method:'HEAD'});
    return await win.loadURL('http://127.0.0.1:7681/');
  } catch (e) {
    const {join} = require('path'); const {existsSync} = require('fs');
    const candidates = [ join(__dirname,'index.html'), join(process.cwd(),'electron','index.html'), join(process.cwd(),'electron','public','index.html') ];
    const local = candidates.find(existsSync);
    if (local) return await win.loadFile(local);
    return await win.loadURL('data:text/html,<h1>CoAgent offline</h1><p>Backend not running.</p>');
  }
}
"@
    if ($raw -notmatch 'function\s+loadCoAgent\(') {
      $raw = $snippet + "`r`n" + $raw
    }
    $raw = $raw -replace "win\.loadURL\([^\)]*127\.0\.0\.1:7681[^\)]*\)", 'loadCoAgent(win)'
    Set-Content -Encoding UTF8 $main $raw
    Info "Patched backend gate in $main"
    $patched++
  }
}
if ($patched -eq 0) {
  foreach($main in $mainCandidates){
    $raw = Get-Content -Raw $main
    if ($raw -notmatch 'function\s+loadCoAgent\(') {
      $raw += @"
  
async function loadCoAgent(win) {
  try {
    await fetch('http://127.0.0.1:7681/', {method:'HEAD'});
    return await win.loadURL('http://127.0.0.1:7681/');
  } catch (e) {
    const {join} = require('path'); const {existsSync} = require('fs');
    const candidates = [ join(__dirname,'index.html'), join(process.cwd(),'electron','index.html'), join(process.cwd(),'electron','public','index.html') ];
    const local = candidates.find(existsSync);
    if (local) return await win.loadFile(local);
    return await win.loadURL('data:text/html,<h1>CoAgent offline</h1>');
  }
}
"@
      $raw = $raw -replace r"win\.loadURL\([^\)]*\)", 'loadCoAgent(win)'
      Set-Content -Encoding UTF8 $main $raw
      Info "Appended backend loader to $main"
      $patched+=1
      break
    }
  }
}

if ($patched -gt 0 -and (Test-Path (Join-Path $repo '.git'))) {
  Push-Location $repo
  try { git add -A; if (-not (git diff --cached --quiet)) { git commit -m "fix(electron): robust backend gate (fallback to local UI when 7681 is down)" } } finally { Pop-Location }
}
