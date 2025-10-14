# Create or update a GitHub release with portable demo artifacts
param(
  [string]$Repo = 'rickballard/MeritRank',
  [string]$Tag  = 'v0.0.1'
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$dir = Join-Path $env:TEMP ("stg-{0}" -f $Tag)
Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue; New-Item -ItemType Directory $dir | Out-Null
@'
@echo off
set URL=https://opename.org/docs/scripttagger/demo.html
where msedge >nul 2>&1 && (
  start "" msedge --app=%URL%
) || start "" %URL%
'@ | Set-Content -Encoding ASCII (Join-Path $dir 'scripttagger.cmd')
Compress-Archive -Path (Join-Path $dir '*') -DestinationPath (Join-Path $dir "scripttagger-demo-windows-x64.zip") -Force
$sha = (Get-FileHash (Join-Path $dir 'scripttagger-demo-windows-x64.zip') -Algorithm SHA256).Hash.ToLower()
"$sha  scripttagger-demo-windows-x64.zip" | Set-Content -Encoding ASCII (Join-Path $dir 'checksums.txt')
gh release create $Tag (Join-Path $dir 'scripttagger-demo-windows-x64.zip') (Join-Path $dir 'checksums.txt') -R $Repo -t "ScripTagger demo $Tag (placeholder)" -n "Opens the hosted demo in an app-style window."
