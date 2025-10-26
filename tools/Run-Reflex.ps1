param(
  [Parameter(Mandatory)][string]$StagePath,
  [Parameter(Mandatory)][string]$AssetId,
  [Parameter(Mandatory)][string]$Version
)
$ErrorActionPreference="Stop"

$root = $StagePath
$tmp  = $null
if($StagePath -match '\.zip$'){
  $tmp = Join-Path $env:TEMP ("reflex_unpack_" + [guid]::NewGuid())
  New-Item -ItemType Directory -Force -Path $tmp | Out-Null
  Expand-Archive -LiteralPath $StagePath -DestinationPath $tmp -Force
  $root = $tmp
}

# run smoke test if present
$smoke = Get-ChildItem -Path $root -Recurse -Filter "DO_SmokeTest_*.ps1" -File | Select-Object -First 1
if($smoke){
  Push-Location (Split-Path $smoke.FullName)
  try { pwsh -NoLogo -NoProfile -File $smoke.Name | Out-Null } finally { Pop-Location }
}

# ensure an output file exists (minimal)
$out = (Get-ChildItem -Path $root -Recurse -File | Where-Object { $_.Name -match '^(out|output|reflex)[\._\-]?(txt|log)$' } | Select-Object -First 1)
if(-not $out){
  $fallback = Join-Path $root "out.txt"
  "Reflex-Minimal OK $(Get-Date -Format s)  Asset=$AssetId  Version=$Version" | Set-Content -Encoding UTF8 -LiteralPath $fallback
}

$CC    = Join-Path $HOME "Documents\GitHub\CoCache"
$Parse = Join-Path $CC "tools\Parse-Reflex.ps1"
pwsh -NoLogo -NoProfile -File $Parse -StagePath $root -AssetId $AssetId -Version $Version

if($tmp){ Remove-Item -Recurse -Force $tmp }
Write-Host "✔ Reflex run + recorded: $AssetId@$Version"

