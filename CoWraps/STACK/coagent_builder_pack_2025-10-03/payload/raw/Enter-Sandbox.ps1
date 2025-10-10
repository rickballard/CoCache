Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$cfgPath = "sandbox.config.json"
if(Test-Path $cfgPath){
  $cfg = Get-Content $cfgPath | ConvertFrom-Json
  if($cfg.net.egress -eq $false){ $env:NO_NETWORK="1" }
}
$env:COAGENT_SANDBOX="1"
Write-Host "Sandbox mode: NO_NETWORK=$($env:NO_NETWORK); COAGENT_SANDBOX=1"
