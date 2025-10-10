param(
  [Parameter(Mandatory)][string]$InputZip,
  [string]$OutZip,
  [string]$SessionHint,
  [string]$ReplyUrl
)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (!(Test-Path $InputZip)) { throw "Input not found: $InputZip" }
if (-not $OutZip) {
  $base = [IO.Path]::GetFileNameWithoutExtension($InputZip)
  $OutZip = Join-Path (Split-Path $InputZip -Parent) ("{0}_RUNNABLE.zip" -f $base)
}

$CT = Join-Path $env:USERPROFILE "Downloads\CoTemp"
$tmp = Join-Path $CT ("wrap_tmp_{0:yyyyMMddHHmmss}" -f (Get-Date))
Remove-Item $tmp -Recurse -Force -EA SilentlyContinue
New-Item -ItemType Directory -Force -Path $tmp | Out-Null

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($InputZip, $tmp, $true)

$run = Join-Path $tmp 'run.ps1'
if (!(Test-Path $run)) {
  @"
# run.ps1 (default HH builder)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
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
$signer = Join-Path "$env:USERPROFILE\Documents\GitHub\CoAgent\tools" 'CoSign-Text.ps1'
if (Test-Path $signer) {
  $sig = & $signer -Text ([IO.File]::ReadAllText($out))
  $sig | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 (Join-Path $root 'HH_Plan.sig.json')
}
"Built: $out" | Set-Content -Encoding UTF8 (Join-Path $root 'out.txt')
"@ | Set-Content -Encoding UTF8 $run
}

if ($SessionHint -or $ReplyUrl) {
  $meta = [ordered]@{ schema = "copayload.meta.v1" }
  if ($SessionHint) { $meta.session_hint = $SessionHint }
  if ($ReplyUrl)    { $meta.reply_url    = $ReplyUrl }
  $metaPath = Join-Path $tmp "_copayload.meta.json"
  $meta | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 $metaPath
}

Remove-Item $OutZip -Force -EA SilentlyContinue
[System.IO.Compression.ZipFile]::CreateFromDirectory($tmp, $OutZip)
Remove-Item $tmp -Recurse -Force -EA SilentlyContinue

Write-Host "Runnable payload -> $OutZip" -ForegroundColor Yellow
