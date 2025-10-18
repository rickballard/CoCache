[CmdletBinding()]
param(
  [string]$SessionId,
  [string]$CycleId,
  [int]$Attempt = 1,
  [string]$Status = 'ready',
  [string]$RepoName = 'CoRepo',
  [string]$Branch = 'main',
  [string]$Prev = '-',
  [string]$NewSha = '',
  [string]$LinesUp = '',
  [string]$LinesDown = '',
  [ValidateSet('violet','orange')] [string]$Theme = 'violet'
)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest

# Resolve this script’s directory robustly
$Here = Split-Path -Parent $MyInvocation.MyCommand.Path

# Guarded ANSI
. (Join-Path $Here 'Set-CoAnsi.ps1')

# Delegate to the real emitter in OneLine mode
& (Join-Path $Here 'Emit-CoPongReceipt.ps1') @PSBoundParameters -OneLine
