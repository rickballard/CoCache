param(
  [switch]$Commit,
  [switch]$Push
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent
"[60-Build] Nothing to build yet (stub). Flags -> Commit=$Commit, Push=$Push"
