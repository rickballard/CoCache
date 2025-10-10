param([string]$RepoRoot = (Get-Location).Path)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

function CopyUtf8($src,$dst){ $d=Split-Path -Parent $dst; if(-not(Test-Path $d)){New-Item -ItemType Directory -Force -Path $d|Out-Null}; Copy-Item -Path $src -Destination $dst -Force }

$base = $PSScriptRoot

CopyUtf8 "$base\config\meritrank.config.json"  (Join-Path $RepoRoot 'config\meritrank.config.json')
CopyUtf8 "$base\config\meritrank.schema.json"  (Join-Path $RepoRoot 'config\meritrank.schema.json')
CopyUtf8 "$base\scripts\validate_config.ps1"   (Join-Path $RepoRoot 'scripts\validate_config.ps1')
CopyUtf8 "$base\scripts\mapper_demo.ps1"       (Join-Path $RepoRoot 'scripts\mapper_demo.ps1')
CopyUtf8 "$base\scripts\score_demo.ps1"        (Join-Path $RepoRoot 'scripts\score_demo.ps1')
CopyUtf8 "$base\.github\workflows\merit-smoke.yml" (Join-Path $RepoRoot '.github\workflows\merit-smoke.yml')

Write-Host "✔ Sprint-3 files installed/updated" -ForegroundColor Green