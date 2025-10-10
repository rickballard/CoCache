param(
  [string]$CoCache = 'C:\Users\Chris\Documents\GitHub\CoCache',
  [string]$Owner   = 'rickballard',
  [switch]$SkipPR
)
$ErrorActionPreference = 'Stop'
function Ensure-Dir([string]$p){ if(!(Test-Path $p)){ New-Item -ItemType Directory -Force -Path $p | Out-Null } }
if(!(Test-Path $CoCache)){ throw "CoCache not found at $CoCache" }
$branch   = "bpoe-docs-{0:yyyyMMddHHmm}" -f (Get-Date)
$docsDir  = Join-Path $CoCache 'docs\bpoe'
$hooksDir = Join-Path $CoCache '.githooks'
Ensure-Dir $docsDir; Ensure-Dir $hooksDir

# ---- Doc contents (compact, no backticks) ----
$THIN_SHIMS = @'
# BPOE: Thin Shims (central CI via CoCache)

Goal: keep each repo light. Add three tiny workflows that call reusable ones in CoCache:

  .github/workflows/smoke.yml
    name: smoke
    on: { push: { branches: ["**"] }, pull_request: {}, workflow_dispatch: {} }
    jobs: { call: { uses: rickballard/CoCache/.github/workflows/bpoe-smoke.yml@main, with: { fail_external: false } } }

  .github/workflows/safety-gate.yml
    name: safety-gate
    on: { pull_request: { types: [opened, synchronize, reopened] } }
    jobs: { call: { uses: rickballard/CoCache/.github/workflows/bpoe-safety-gate.yml@main } }

  .github/workflows/self-evolve.yml
    name: self-evolve
    on: { workflow_dispatch: {}, schedule: [ { cron: "13 4 * * *" } ] }
    jobs: { call: { uses: rickballard/CoCache/.github/workflows/bpoe-self-evolve.yml@main } }

Pin to a SHA for determinism by replacing @main with a CoCache commit.
If a repo is DO-only, stage shims under .github/workflows.disabled/ until allowed.
'@

$BLOB_GUARD = @'
# BPOE: Blob Guard (100 MB)

GitHub rejects any blob >= 100 MB. This repo installs a pre-push hook that blocks such pushes locally.

Install:
  1) core.hooksPath is set to .githooks in this kit.
  2) Hook files: .githooks/pre-push and .githooks/pre-push.ps1

If you already committed a big file (example heavy paths):
  - docs/index/ADVICE-INDEX.md
  - docs/index/TODO-INDEX.md

Rewrite steps (with backups):

  1) Backup everything to a bundle (outside the repo):
       git bundle create ../pre-filter-$(Get-Date -Format yyyyMMddHHmmss).bundle --all

  2) Remove heavy paths from history (requires git-filter-repo in PATH):
       # Install: pip install git-filter-repo   (or choco install git-filter-repo)
       git filter-repo --force
         --path docs/index/ADVICE-INDEX.md
         --path docs/index/TODO-INDEX.md
         --invert-paths

  3) Force-push (coordinate with collaborators):
       git push --force-with-lease origin main
'@

$BRANCH_HYGIENE = @'
# BPOE: Branch Hygiene

Classes:
  - KEEP: open/draft PR or active
  - REWRITE: contains >=100MB blob(s) or touches known heavy paths
  - ARCHIVE: merged to default, or stale and no unique commits

Use your branch-audit script to emit CSV/JSON, then:
  - tag backup/* before deletes
  - optionally create .bundle snapshots
  - delete local branch (and remote ref if desired; deletes aren’t blocked)
'@

$ISSUEOPS = @'
# ISSUEOPS quicksheet

Dispatch smoke:
  gh workflow run smoke.yml --ref <branch> -R OWNER/REPO

Pin shims to current CoCache SHA:
  $sha = (git -C "C:\Users\Chris\Documents\GitHub\CoCache" rev-parse HEAD).Trim()
  $targets = @("InSeed","GroupBuild-website","CoCivium","CoCivium-website","CoAgent","GIBindex","CoLaminar","rickballard")
  foreach($r in $targets){
    $wf = "C:\Users\Chris\Documents\GitHub\$r\.github\workflows"
    if(Test-Path $wf){
      foreach($f in @("smoke.yml","safety-gate.yml","self-evolve.yml")){
        $p = Join-Path $wf $f
        if(Test-Path $p){ (Get-Content $p) -replace "@main","@$sha" | Set-Content $p }
      }
    }
  }
'@

$PREPUSH_BASH = @'
#!/usr/bin/env bash
set -euo pipefail
exec pwsh -NoProfile -File "$(dirname "$0")/pre-push.ps1"
'@

$PREPUSH_PS1 = @'
Param()
[int64]$Limit = 100MB
$lines = @(); while($l = [Console]::In.ReadLine()){ if($l -and $l.Trim()){ $lines += $l } }
if($lines.Count -eq 0){ exit 0 }

function Get-BatchCheck([string[]]$Shas){
  if(!$Shas){ return @() }
  $txt = ($Shas -join "`n") + "`n"
  $psi = New-Object System.Diagnostics.ProcessStartInfo
  $psi.FileName = 'git'; $psi.Arguments = 'cat-file --batch-check'
  $psi.UseShellExecute = $false; $psi.RedirectStandardInput = $true; $psi.RedirectStandardOutput = $true
  $p = [System.Diagnostics.Process]::Start($psi)
  $p.StandardInput.Write($txt); $p.StandardInput.Close()
  $out = $p.StandardOutput.ReadToEnd(); $p.WaitForExit()
  return $out -split "`n"
}

$found = New-Object System.Collections.Generic.List[object]
foreach($ln in $lines){
  $parts = $ln -split '\s+'; if($parts.Count -lt 4){ continue }
  $local,$localSha,$remote,$remoteSha = $parts[0..3]
  $range = if($remoteSha -match '^[0]{40}$'){ $localSha } else { "$remoteSha..$localSha" }

  $map = @{}
  foreach($row in (git rev-list --objects $range 2>$null)){
    $p = $row -split ' '
    if($p[0] -and -not $map.ContainsKey($p[0])){ $map[$p[0]] = ($p.Count -gt 1 ? ($p[1..($p.Count-1)] -join ' ') : '') }
  }
  foreach($r in (Get-BatchCheck @($map.Keys))){
    if(-not $r){ continue }
    $f = $r -split '\s+'
    if($f.Count -ge 3 -and $f[1] -eq 'blob'){
      $size = [int64]$f[2]
      if($size -ge $Limit){
        $found.Add([pscustomobject]@{ sha=$f[0]; mb=[math]::Round($size/1MB,2); path=$map[$f[0]]; local=$local; remote=$remote })
      }
    }
  }
}

if($found.Count -gt 0){
  Write-Host '[BLOB-GUARD] Push blocked: blobs >= 100MB present.' -ForegroundColor Red
  $found | Sort-Object mb -Descending | Format-Table -Auto sha,mb,path,local,remote | Out-String | Write-Host
  Write-Host 'See docs/bpoe/BLOB_GUARD.md for rewrite steps.' -ForegroundColor Yellow
  exit 1
}
exit 0
'@

# ---- Write files ----
Set-Content -Encoding UTF8 (Join-Path $docsDir 'THIN_SHIMS.md')     $THIN_SHIMS
Set-Content -Encoding UTF8 (Join-Path $docsDir 'BLOB_GUARD.md')     $BLOB_GUARD
Set-Content -Encoding UTF8 (Join-Path $docsDir 'BRANCH_HYGIENE.md') $BRANCH_HYGIENE
Set-Content -Encoding UTF8 (Join-Path $CoCache  'docs\ISSUEOPS.md') $ISSUEOPS

Set-Content -Encoding UTF8 (Join-Path $hooksDir 'pre-push')     $PREPUSH_BASH
Set-Content -Encoding UTF8 (Join-Path $hooksDir 'pre-push.ps1') $PREPUSH_PS1

# normalize bash shim to LF
$bashPath = Join-Path $hooksDir 'pre-push'
(Get-Content $bashPath -Raw).Replace("`r`n","`n") | Set-Content -NoNewline $bashPath

# ---- Commit + PR ----
Push-Location $CoCache
try {
  git checkout -B $branch | Out-Null
  git config core.hooksPath .githooks
  git update-index --add --chmod=+x '.githooks/pre-push' 2>$null | Out-Null
  git add 'docs/bpoe/*.md' 'docs/ISSUEOPS.md' '.githooks/pre-push' '.githooks/pre-push.ps1'
  $status = git status --porcelain
  if([string]::IsNullOrWhiteSpace($status)){
    Write-Host 'No changes to commit.' -ForegroundColor Yellow
  } else {
    git commit -m 'docs(bpoe): thin shims, blob guard, branch hygiene; ISSUEOPS quicksheet' | Out-Null
  }
  git push -u origin $branch
  if(-not $SkipPR){
    if(Get-Command gh -ErrorAction SilentlyContinue){
      gh config set prompt disabled 2>$null | Out-Null
      gh pr create --fill --title 'BPOE: Thin Shims + Blob Guard + Branch Hygiene + ISSUEOPS refresh' --body 'Centralized CI docs, pre-push blob guard, branch hygiene notes, IssueOps quicksheet.' | Out-Null
      Write-Host "PR opened for $branch." -ForegroundColor Green
    } else {
      Write-Host "gh not found; open a PR for branch $branch" -ForegroundColor Yellow
    }
  } else {
    Write-Host "SkipPR requested; branch pushed: $branch" -ForegroundColor Yellow
  }
} finally { Pop-Location }
Write-Host "✅ CoCache BPOE/ISSUEOPS kit updated on $branch" -ForegroundColor Green