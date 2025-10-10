param(
  [Parameter(Mandatory=$true)][string]$RepoPath,
  [int]$Port = 7681
)
$ErrorActionPreference = 'Stop'

if (!(Test-Path $RepoPath)) { throw "RepoPath not found: $RepoPath" }
if (!(Test-Path (Join-Path $RepoPath '.git'))) { throw "Not a git repo: $RepoPath" }

$devDir = Join-Path $RepoPath '.dev\backend-interceptor'
New-Item -ItemType Directory -Force -Path $devDir | Out-Null

# Write a simple local backend config (harmless if app ignores it)
$configPath = Join-Path $devDir 'backend.local.json'
$config = @{
  enabled = $true
  baseUrl = "http://127.0.0.1:$Port"
  note    = "Dev-only interceptor config. Safe to delete."
} | ConvertTo-Json -Depth 3
Set-Content -Encoding UTF8 -Path $configPath -Value $config

# Write a small README for discoverability
$readme = @"
This folder is created by Apply-Backend-Interceptor.ps1.

Files:
- backend.local.json : points the UI at a dev backend (127.0.0.1:$Port)
- (optional) you can run Start-StaticBackend.ps1 from the kit to serve a minimal mock.

Remove with Remove-Backend-Interceptor.ps1 or by deleting .dev\backend-interceptor.
"@
Set-Content -Encoding UTF8 -Path (Join-Path $devDir 'README.txt') -Value $readme

Write-Host "✅ Installed dev interceptor config at: $configPath" -ForegroundColor Green
