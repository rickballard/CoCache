param([string]$RepoRoot = (Get-Location).Path)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
function WriteUtf8($p,$s){ $d=Split-Path -Parent $p; if(-not(Test-Path $d)){New-Item -ItemType Directory -Force -Path $d|Out-Null}; [IO.File]::WriteAllText($p,$s,[Text.UTF8Encoding]::new($true)) }

$mapDst = Join-Path $RepoRoot 'scripts\mapper_demo.ps1'
$scoreDst= Join-Path $RepoRoot 'scripts\score_demo.ps1'
$wfDst  = Join-Path $RepoRoot '.github\workflows\merit-smoke.yml'

$mapSrc = Join-Path $PSScriptRoot 'scripts\mapper_demo.ps1'
$scoreSrc=Join-Path $PSScriptRoot 'scripts\score_demo.ps1'
$wfSrc  = Join-Path $PSScriptRoot '.github\workflows\merit-smoke.yml'

Copy-Item -Path $mapSrc -Destination $mapDst -Force
Copy-Item -Path $scoreSrc -Destination $scoreDst -Force
Copy-Item -Path $wfSrc -Destination $wfDst -Force

Write-Host "✔ Installed scripts/mapper_demo.ps1, scripts/score_demo.ps1"
Write-Host "✔ Updated .github/workflows/merit-smoke.yml (matrix + artifacts + summary)"
Write-Host ">> Sprint-2 patch applied" -ForegroundColor Green