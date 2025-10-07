# BN_Canonical_Pull.ps1 — refresh canonical BN file from web or Recovery
[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repo = (git rev-parse --show-toplevel) 2>$null
if(-not $repo){
  throw "Run inside your git repo."
}
Set-Location $repo

$destRel = "Insights\BN_Story_being-noname_v1.0.md"
$dest    = Join-Path $repo $destRel
New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null

$ok = $false

# Try web fetch
try{
  $url = "https://raw.githubusercontent.com/rickballard/CoCivium/main/insights/Insight_Story_Being_Noname_c2_20250801.md"
  $tmp = Join-Path $env:TEMP ("bn_{0}.md" -f (Get-Random))
  Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $tmp -TimeoutSec 20
  if((Get-Item $tmp).Length -gt 0){
    Copy-Item $tmp $dest -Force
    Remove-Item $tmp -Force
    $ok = $true
  }
} catch {
  # ignore
}

if(-not $ok){
  # Fallback to Recovery copies
  $candidates = @(
    "Recovery\CrossRepo\Insights__BN_Story_being-noname_v1.0.md",
    "Recovery\Strays\Insights__BN_Story_being-noname_v1.0.md",
    "Recovery\CrossRepo\insights__story-being-noname.md",
    "Recovery\Strays\insights__story-being-noname.md"
  ) | ForEach-Object { Join-Path $repo $_ } | Where-Object { Test-Path $_ }

  if($candidates){
    Copy-Item $candidates[0] $dest -Force
    $ok = $true
  }
}

if($ok){
  git add -- $dest 2>$null
  $st = git diff --cached --name-only
  if($st){
    git commit -m "bn(sync): update canonical 'Being Noname'"
    git push
  }
  Write-Host "Done: $destRel"
} else {
  Write-Host "BN sync skipped — no source found." -ForegroundColor Yellow
}
