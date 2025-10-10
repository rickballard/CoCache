Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
function Note($m){ Write-Host "[40-Plan] $m" }
$wt = Get-ChildItem "$HOME\Documents\GitHub\CoAgent__mvp3*" -Directory -ErrorAction SilentlyContinue |
      Sort-Object LastWriteTime -Desc | Select-Object -First 1
if(-not $wt){ Note "Skipped (worktree not found)"; return }
$repo = $wt.FullName
$docs = Join-Path $repo 'docs'
New-Item -ItemType Directory -Force -Path $docs | Out-Null
$packRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$tpl = Join-Path (Join-Path $packRoot 'templates') 'MVP3_Plan.md'
$target = Join-Path $docs 'CoAgent_MVP3_Plan.md'
Copy-Item $tpl $target -Force
Note "Wrote $target"
$readme = Join-Path $repo 'README.md'
if(Test-Path $readme){
  $content = Get-Content $readme -Raw
  if($content -notmatch '## CoAgent MVP3 Plan'){
    $banner = @"
## CoAgent MVP3 Plan

See **docs/CoAgent_MVP3_Plan.md** for the current product plan, install modes (Temporary vs Permanent), zero-footprint behavior, and training flow.
"@
    $content = $banner + "`r`n" + $content
    Set-Content -LiteralPath $readme -Value $content -Encoding UTF8
    Note "Prepended README call-out."
  } else {
    Note "README already mentions the plan (skipped)."
  }
} else {
  $rm = @"
# CoAgent (MVP3)

See **docs/CoAgent_MVP3_Plan.md** for the current product plan, install modes, and training flow.
"@
  Set-Content -LiteralPath $readme -Value $rm -Encoding UTF8
  Note "Created README.md with plan call-out."
}
