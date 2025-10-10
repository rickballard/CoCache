
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = (Resolve-Path (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "..")).Path
$cfgDir = Join-Path $root ".coagent"
New-Item -ItemType Directory -Force $cfgDir | Out-Null
$cfg = @{ NO_NETWORK = 1; note = "Respect this in tools and adapters."; set_at = (Get-Date).ToString("s") } | ConvertTo-Json -Depth 5
$cfgPath = Join-Path $cfgDir "sandbox.config.json"
$cfg | Set-Content -Encoding UTF8 $cfgPath
$env:NO_NETWORK = "1"
Write-Host "✅ Sandbox ON — wrote $cfgPath" -ForegroundColor Green
Write-Host "   Conventions: respect NO_NETWORK=1 and ./tools/* should short-circuit egress."
Write-Host "   Session env set: NO_NETWORK=1 (effective for this shell)"
