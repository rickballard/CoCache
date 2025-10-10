param(
  [Parameter(Mandatory=$true)][string]$RepoPath,
  [int]$Port = 7681
)
$ErrorActionPreference = 'Stop'
if(!(Test-Path $RepoPath)){ throw "RepoPath not found: $RepoPath" }
$cfgDir = Join-Path $RepoPath ".dev/backend-interceptor"
New-Item -ItemType Directory -Force -Path $cfgDir | Out-Null
$cfg = @{
  backend = @{ type = "static"; url = "http://127.0.0.1:$Port/" }
}
$cfgPath = Join-Path $cfgDir "backend.local.json"
$cfg | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 $cfgPath
Write-Host "✅ Installed dev interceptor config at: $cfgPath" -ForegroundColor Green
