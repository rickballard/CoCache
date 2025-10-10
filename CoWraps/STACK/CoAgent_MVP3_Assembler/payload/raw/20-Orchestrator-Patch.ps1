Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Note([string]$m){ Write-Host "[20-Orch] $m" }

$wt = Get-ChildItem "$HOME\Documents\GitHub\CoAgent__mvp3*" -Directory -ErrorAction SilentlyContinue |
      Sort-Object LastWriteTime -Descending | Select-Object -First 1
if(-not $wt){ Note "No worktree found; skipping."; return }

$orch = Join-Path $wt.FullName 'tools\Start-MVP3-Orchestrator.ps1'
if(-not (Test-Path $orch)){ Note "No orchestrator at $orch; skipping."; return }

$sessionUrl = $env:COAGENT_SESSION_URL
if([string]::IsNullOrWhiteSpace($sessionUrl)){
  Note "Env COAGENT_SESSION_URL not set; leaving file unchanged."
  return
}

$pairKey = ($sessionUrl -replace '[^\w-]','_')

Note "Target: $orch"
$bak = "$orch.bak_{0}" -f (Get-Date -f 'yyyyMMdd-HHmmss')
Copy-Item $orch $bak -Force
Note "Backup -> $bak"

$text = Get-Content -LiteralPath $orch -Raw

$new = $text
$new = $new -replace "'REPLACE_ME_WITH_URL'", ("'{0}'" -f $sessionUrl)
$new = $new -replace '"REPLACE_ME_WITH_URL"', ('"{0}"' -f $sessionUrl)
$new = $new -replace 'pair_REPLACE_ME_WITH_URL', ("pair_{0}" -f $pairKey)

if($new -ne $text){
  Set-Content -LiteralPath $orch -Value $new -Encoding UTF8
  Note "Placeholders replaced. Parse-checking…"
  $t=$null;$e=$null
  [void][System.Management.Automation.Language.Parser]::ParseFile($orch,[ref]$t,[ref]$e)
  if($e -and $e.Count){
    Note "Parse failed; restoring backup."
    Copy-Item $bak $orch -Force
    throw "Parse failure after placeholder replace."
  }else{
    Note "Parse clean."
  }
}else{
  Note "No placeholders found; nothing changed."
}
