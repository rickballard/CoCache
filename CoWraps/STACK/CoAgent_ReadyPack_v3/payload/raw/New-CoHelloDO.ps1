function New-CoHelloDO {
  [CmdletBinding()]
  param([string]$RepoPath = (Join-Path $HOME 'Desktop\CoAgent_SandboxRepo'))
  $session = if ($env:COSESSION_ID){$env:COSESSION_ID}else{"manual"}
  $inbox   = Join-Path (Join-Path $HOME 'Downloads\CoTemp') ("sessions\{0}\inbox" -f $session)
  if (-not (Test-Path $inbox)) { New-Item -ItemType Directory -Force -Path $inbox | Out-Null }
  $name = "DO_00_Hello_{0}.ps1" -f (Get-Date -Format 'HHmmss')
  $path = Join-Path $inbox $name
  $body = @"
<# ---
title: "DO-hello"
session_id: "$session"
repo: { name: "Sandbox", path: "$RepoPath" }
risk: { writes: false, network: false, secrets: false, destructive: false }
brief: "Hello from CoTemp"
consent: { allow_writes: false, allow_network: false }
--- #>
# [PASTE IN POWERSHELL]
"Hello from DO in CoTemp - $(Get-Date -Format o)"
$PSVersionTable.PSVersion
"@
  Set-Content -LiteralPath $path -Value $body -Encoding UTF8
  Write-Host ("Queued -> {0}" -f $path) -ForegroundColor Green
  return $path
}
