param(
  [Parameter(Mandatory)][string]$StagePath,   # folder or .zip
  [Parameter(Mandatory)][string]$AssetId,
  [Parameter(Mandatory)][string]$Version
)
$ErrorActionPreference="Stop"

# If a DO_SmokeTest exists, run it; otherwise just parse existing out.txt
$root = $StagePath
if($StagePath -match '\.zip$'){
  $tmp = Join-Path $env:TEMP ("reflex_unpack_" + [guid]::NewGuid())
  New-Item -ItemType Directory -Force -Path $tmp | Out-Null
  Expand-Archive -LiteralPath $StagePath -DestinationPath $tmp -Force
  $root = $tmp
}

$smoke = Get-ChildItem -Path $root -Recurse -Filter "DO_SmokeTest_*.ps1" -File | Select-Object -First 1
if($smoke){
  Push-Location (Split-Path $smoke.FullName)
  try { pwsh -NoLogo -NoProfile -File $smoke.Name | Out-Null } finally { Pop-Location }
}

# Ensure out.txt exists now; then parse+log via existing tool
$CC = Join-Path $HOME "Documents\GitHub\CoCache"
$Parse = Join-Path $CC "tools\Parse-Reflex.ps1"
if(!(Test-Path $Parse)){ throw "Missing $Parse — run the earlier install step." }
pwsh -NoLogo -NoProfile -File $Parse -StagePath $root -AssetId $AssetId -Version $Version

if($tmp){ Remove-Item -Recurse -Force $tmp }
Write-Host "✔ Reflex run + recorded: $AssetId@$Version"
