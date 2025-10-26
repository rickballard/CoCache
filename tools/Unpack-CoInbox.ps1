param(
  [string]$Root  = "$HOME\Documents\GitHub\CoCache",
  [string]$Stage = "$HOME\Documents\GitHub\CoCache\advice\.stage"
)
$ErrorActionPreference='Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem

$Inbox = Join-Path $Root 'advice\inbox'
New-Item -ItemType Directory -Force -Path $Stage | Out-Null

$zips = Get-ChildItem -Path $Inbox -File -Filter *.zip -ErrorAction SilentlyContinue
if(-not $zips){ Write-Host "No ZIPs in inbox." -ForegroundColor Yellow; exit }

foreach($z in $zips){
  $name = [IO.Path]::GetFileNameWithoutExtension($z.Name)
  $out  = Join-Path $Stage $name
  if(Test-Path $out){ Remove-Item -Recurse -Force $out }
  New-Item -ItemType Directory -Force -Path $out | Out-Null
  try{
    [IO.Compression.ZipFile]::ExtractToDirectory($z.FullName,$out)
    try{ (Get-Item $out).LastWriteTime = (Get-Item $z.FullName).LastWriteTime }catch{}
    Write-Host "Unpacked: $($z.Name) -> $out" -ForegroundColor Green
  }catch{
    Write-Host "Failed to unpack $($z.Name): $($_.Exception.Message)" -ForegroundColor Red
  }
}
Write-Host "Tip: look for README.md and Deliverable_Manifest.md under $Stage" -ForegroundColor Cyan
