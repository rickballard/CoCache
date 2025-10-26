param(
  [string]$OutZip = "vault/_HP57_$(Get-Date -Format yyyy-MM-dd_HHmmss).zip",
  [string]$IncludeGlob = "corpus/humans/**/*.md"
)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
$pw = $env:HP57_PW
if([string]::IsNullOrWhiteSpace($pw)){ throw "Set HP57_PW env var first." }
$files = @(Get-ChildItem -Recurse -File -Path $IncludeGlob -ErrorAction SilentlyContinue)
if(-not $files -or $files.Count -eq 0){ throw "No files matched $IncludeGlob" }
New-Item -ItemType Directory -Force (Split-Path $OutZip) | Out-Null
# Require 7z/7za in PATH
$seven = (Get-Command 7z -ErrorAction SilentlyContinue) ?? (Get-Command 7za -ErrorAction SilentlyContinue)
if(-not $seven){ throw "7-Zip CLI (7z/7za) not found in PATH." }
& $seven.Source a -p"$pw" -mhe=on -tzip -- "$OutZip" $($files.FullName) | Out-Null
Write-Host "HP57 Vault written: $OutZip" -f Green

