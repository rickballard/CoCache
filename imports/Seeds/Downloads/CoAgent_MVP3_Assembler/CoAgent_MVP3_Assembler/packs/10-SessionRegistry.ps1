Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent
$StateDir   = Join-Path $ScriptRoot 'state'
$Registry   = Join-Path $StateDir 'sessions.json'

$sessionUrl = $env:COAGENT_SESSION_URL
$pairKey    = if($sessionUrl){ ($sessionUrl -replace '[^\w-]','_') } else { 'no_url' }

$data = @{ updated=(Get-Date).ToString('s'); sessionUrl=$sessionUrl; pairKey=$pairKey }
$json = $data | ConvertTo-Json -Depth 5
$json | Out-File -FilePath $Registry -Encoding UTF8

"[10-Registry] sessionUrl: $sessionUrl"
"[10-Registry] pairKey   : $pairKey"
"[10-Registry] wrote     : $Registry"
