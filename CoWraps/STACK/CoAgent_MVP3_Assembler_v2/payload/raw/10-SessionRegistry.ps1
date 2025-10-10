Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$packRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$state = Join-Path $packRoot 'state'
New-Item -ItemType Directory -Force -Path $state | Out-Null
$sessionUrl = $env:COAGENT_SESSION_URL
$pairKey = if($sessionUrl){ ($sessionUrl -replace '[^\w-]','_' -replace '_{2,}','_') } else { 'no_url' }
$data = [pscustomobject]@{
  updated    = (Get-Date).ToString("s")
  pairKey    = $pairKey
  sessionUrl = $sessionUrl
}
$data | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $state 'sessions.json') -Encoding UTF8
Write-Host "[10-Registry] sessionUrl: $sessionUrl"
Write-Host "[10-Registry] pairKey   : $pairKey"
Write-Host "[10-Registry] wrote     : $(Join-Path $state 'sessions.json')"
