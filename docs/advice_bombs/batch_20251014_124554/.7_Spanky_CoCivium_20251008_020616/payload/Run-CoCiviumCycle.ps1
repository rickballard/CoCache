[CmdletBinding()]
param(
  [string]$Downloads = (Join-Path $HOME 'Downloads'),
  [string]$Pattern   = 'CoCivium_*_v*.zip',
  [switch]$KeepExtract
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
Write-Host "Looking in: $Downloads" -ForegroundColor Cyan
$zips = Get-ChildItem -Path $Downloads -Filter $Pattern -File -ErrorAction SilentlyContinue
if(-not $zips){ Write-Host "No packages found matching $Pattern" -ForegroundColor Yellow; return }
function Parse-PkgInfo {
  param([IO.FileInfo]$File)
  $name = $File.Name
  if($name -match '^(?<base>.+?)_v(?<ver>\d+(?:\.\d+){1,3}(?:[-.][A-Za-z0-9]+)?)\.zip$'){
    $base    = $matches.base
    $verText = $matches.ver.Trim('.')
    $verCore = ($verText -replace '[^\d\.].*$','')
    $v = $null
    if(-not [System.Version]::TryParse($verCore, [ref]$v)){
      $parts = ($verCore -split '\.')
      while($parts.Count -lt 3){ $parts += '0' }
      [void][System.Version]::TryParse(($parts[0..2] -join '.'), [ref]$v)
    }
    if($v){ [pscustomobject]@{ File=$File; Base=$base; VersionText=$verText; Version=$v } }
  }
}
$parsed = $zips | ForEach-Object { Parse-PkgInfo $_ } | Where-Object { $_ }
if(-not $parsed){ Write-Error "No versioned packages found (expecting '*_v<semver>.zip')."; return }
$parsed | Sort-Object Base, Version -Descending |
  Format-Table Base, VersionText, @{n='Zip';e={$_.File.Name}} -AutoSize
$chosen = $parsed | Group-Object Base | ForEach-Object { $_.Group | Sort-Object Version -Descending | Select-Object -First 1 }
foreach($pkg in $chosen){
  $zip  = $pkg.File.FullName
  $base = $pkg.Base
  $verT = $pkg.VersionText
  Write-Host "`n==> Running $($pkg.File.Name)" -ForegroundColor Green
  $dest = Join-Path $env:TEMP ("{0}_{1}_{2}" -f $base, $verT, (Get-Random))
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  try { Expand-Archive -LiteralPath $zip -DestinationPath $dest -Force } catch {
    Write-Host "✗ Expand failed: $($_.Exception.Message)" -ForegroundColor Red; Remove-Item -Recurse -Force $dest -ErrorAction SilentlyContinue; continue }
  $do = Join-Path $dest 'do.ps1'
  if(-not (Test-Path $do)){ Write-Host "✗ Package missing do.ps1 → $zip" -ForegroundColor Red; Remove-Item -Recurse -Force $dest -ErrorAction SilentlyContinue; continue }
  try { & pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File $do; Write-Host "✓ Package succeeded." -ForegroundColor Green }
  catch { Write-Host "✗ Package failed: $($_.Exception.Message)" -ForegroundColor Red }
  finally { Remove-Item -Recurse -Force $dest -ErrorAction SilentlyContinue }
  Get-ChildItem -Path $Downloads -Filter "$base*_v*.zip" -File | Remove-Item -Force -ErrorAction SilentlyContinue
  Write-Host "🧹 Cleaned older/used zips for $base." -ForegroundColor DarkGreen
}
