Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
function Note($m){ Write-Host "[41-Help] $m" }
$wt = Get-ChildItem "$HOME\Documents\GitHub\CoAgent__mvp3*" -Directory -ErrorAction SilentlyContinue |
      Sort-Object LastWriteTime -Desc | Select-Object -First 1
if(-not $wt){ Note "Skipped (worktree not found)"; return }
$repo = $wt.FullName
$docs = Join-Path $repo 'docs'
New-Item -ItemType Directory -Force -Path $docs | Out-Null
$packRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$tplHelp   = Join-Path (Join-Path $packRoot 'templates') 'HELP_FirstRun.md'
$tplTrain  = Join-Path (Join-Path $packRoot 'templates') 'TRAINING_Script.md'
Copy-Item $tplHelp  (Join-Path $docs 'CoAgent_HELP_FirstRun.md') -Force
Copy-Item $tplTrain (Join-Path $docs 'CoAgent_TRAINING_Script.md') -Force
Note "Wrote help + training docs into repo/docs."
