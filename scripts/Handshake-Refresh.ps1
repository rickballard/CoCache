[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)] [string]$CoCacheRepos,
  [Parameter(Mandatory=$true)] [string]$OutHandshake,
  [string]$Target = "$HOME\Documents\GitHub\CoAgent\scripts\Consume-CoCacheRepos.ps1"
)

if (Test-Path -LiteralPath $Target) {
  pwsh -NoProfile -ExecutionPolicy Bypass -File $Target `
    -CoCacheRepos $CoCacheRepos -OutHandshake $OutHandshake -Verbose
} else {
  "handshake: skipped (script not found): $Target"
}
