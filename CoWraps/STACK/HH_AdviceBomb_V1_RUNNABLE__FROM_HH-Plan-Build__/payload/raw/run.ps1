# run.ps1 (generic HH builder)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = $PSScriptRoot
# If a manifest exists, respect file order; else gather all *.md recursively
$manifest = Join-Path $root '_hp.manifest.json'
if (Test-Path $manifest) {
  try {
    $cfg = Get-Content $manifest -Raw | ConvertFrom-Json
    $paths = @()
    foreach($pat in $cfg.order){ $paths += Get-ChildItem -Path (Join-Path $root $pat) -File -Recurse -EA SilentlyContinue }
    $mds = $paths | Where-Object { $_.Extension -ieq '.md' }
  } catch { $mds = Get-ChildItem $root -Recurse -File -Filter *.md }
} else {
  $mds = Get-ChildItem $root -Recurse -File -Filter *.md | Sort-Object FullName
}

if (-not $mds) { "No markdown files found." | Set-Content (Join-Path $root 'out.txt'); exit 0 }

$out = Join-Path $root 'HH_Plan.md'
$header = @("# Hitchhiker Plan (auto-built)", "", "> build: $(Get-Date -Format o)", "")
$header | Set-Content -Encoding UTF8 $out
foreach($m in $mds){
  Add-Content -Encoding UTF8 $out ("`n`n<!-- {0} -->`n" -f (Resolve-Path $m))
  Get-Content $m -Raw | Add-Content -Encoding UTF8 $out
}

# Optional: co-sign (if local signer exists)
$signer = Join-Path "$env:USERPROFILE\Documents\GitHub\CoAgent\tools" 'CoSign-Text.ps1'
if (Test-Path $signer) {
  $sig = & $signer -Text ([IO.File]::ReadAllText($out))
  $sig | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 (Join-Path $root 'HH_Plan.sig.json')
}

"Built: $out" | Set-Content -Encoding UTF8 (Join-Path $root 'out.txt')
