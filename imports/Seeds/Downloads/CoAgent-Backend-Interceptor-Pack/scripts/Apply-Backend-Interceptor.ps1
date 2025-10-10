[CmdletBinding()]
param([string]$RepoPath = "$HOME\Documents\GitHub\CoAgent")
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
function Info($m){ Write-Host "[INFO] $m" }

$repo = Resolve-Path $RepoPath -ErrorAction SilentlyContinue
if (-not $repo) { throw "Repo not found: $RepoPath" }

$mainFiles = @(
  "electron\main.js","electron\src\main.js","electron\src\main.ts",
  "electron\main.ts","electron\app\main.js","electron\app\main.ts"
) | ForEach-Object { Join-Path $repo $_ } | Where-Object { Test-Path $_ }
if (-not $mainFiles) { throw "No Electron main file found under electron/" }

$inject = @"
//
// ===== CoAgent Backend Interceptor (autoinjected) =====
const { app, BrowserWindow, session } = require("electron");
const { join } = require("path");
const { existsSync } = require("fs");

async function _pingBackend(){
  try { await fetch("http://127.0.0.1:7681/", { method: "HEAD" }); return true; } catch { return false; }
}
function _localIndex(){
  const c = [ join(__dirname,"index.html"), join(process.cwd(),"electron","index.html"), join(process.cwd(),"electron","public","index.html") ];
  return c.find(existsSync);
}
async function _safeLoad(win){
  if (process.env.COAGENT_FORCE_LOCAL === "1") {
    const local = _localIndex();
    return local && win.loadFile ? win.loadFile(local) : win.loadURL("data:text/html,offline");
  }
  if (await _pingBackend()) return "ok";
  const local = _localIndex();
  if (local && win.loadFile) { await win.loadFile(local); return "local"; }
  await win.loadURL("data:text/html,<h1>CoAgent offline</h1><p>Backend not running.</p>");
  return "inline";
}
// Runtime guard: catch failures and re-route
app.on("web-contents-created", (_evt, contents) => {
  const tryLocal = async () => {
    const w = BrowserWindow.fromWebContents(contents);
    if (w && typeof _safeLoad === "function") await _safeLoad(w);
  };
  contents.on("did-fail-load", async (_e, code, _desc, url, isMainFrame) => {
    if (isMainFrame && (code === -102 || /127\.0\.0\.1:7681/.test(url||""))) await tryLocal();
  });
  contents.on("will-navigate", async (e, url) => {
    if (/127\.0\.0\.1:7681/.test(url)) { e.preventDefault(); await tryLocal(); }
  });
});
// ===== /CoAgent Backend Interceptor =====
"@

foreach($f in $mainFiles){
  $raw = Get-Content -Raw $f
  if ($raw -notmatch 'CoAgent Backend Interceptor') {
    if ($raw -match "require\(['""]electron['""]\)") {
      $raw = $raw -replace "(require\(['""]electron['""]\).*)", "`$1`r`n`r`n$inject"
    } else {
      $raw = $inject + "`r`n" + $raw
    }
    # Replace any direct .loadURL calls to localhost with _safeLoad
    $p1 = '([A-Za-z_\$][\w\$]*)\.loadURL\(\s*"http://127\.0\.0\.1:7681/[^"]*"\s*\)'
    $p2 = "([A-Za-z_\$][\w\$]*)\.loadURL\(\s*'http://127\.0\.0\.1:7681/[^']*'\s*\)"
    $raw = [regex]::Replace($raw, $p1, '_safeLoad($1)')
    $raw = [regex]::Replace($raw, $p2, '_safeLoad($1)')
    Set-Content -Encoding UTF8 $f $raw
    Info "Patched + injected interceptor -> $f"
  } else {
    Info "Interceptor already present -> $f"
  }
}

# Pair script hint (lets you force local for demos)
$pair = Join-Path $repo "tools\Pair-CoSession.ps1"
if (Test-Path $pair) {
  $praw = Get-Content -Raw $pair
  if ($praw -notmatch 'COAGENT_FORCE_LOCAL') {
    $hint = '`$env:COAGENT_FORCE_LOCAL = `$env:COAGENT_FORCE_LOCAL -as [string]; if (-not `$env:COAGENT_FORCE_LOCAL) { `$env:COAGENT_FORCE_LOCAL = "0" }'
    $praw = $hint + "`r`n" + $praw
    Set-Content -Encoding UTF8 $pair $praw
    Info "Added COAGENT_FORCE_LOCAL hint to Pair-CoSession.ps1 (set to 1 to force local fallback)"
  }
}
