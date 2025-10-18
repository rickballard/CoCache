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

. (Join-Path $Here 'Set-CoAnsi.ps1')

# Delegate to the real emitter in OneLine mode
# Guarded ANSI (best-effort)
$SetAnsi = Join-Path $Here 'Set-CoAnsi.ps1'
if(Test-Path $SetAnsi){ . $SetAnsi } else {
  try{ if($PSStyle.OutputRendering -eq 'PlainText'){ $PSStyle.OutputRendering = 'Ansi' } }catch{}
}

# Violet banner
$esc=[char]27
$supports = ($Host.Name -ne 'ConsoleHost') -or ($PSStyle.OutputRendering -ne 'PlainText')
$on  = $supports ? "$esc[38;5;135m" : ''
$off = $supports ? "$esc[0m"        : ''
Write-Host ""
Write-Host ($on + ('='*64)) -NoNewline; Write-Host $off
Write-Host ($on + "   CoPONG (one-line follows)   ") -NoNewline; Write-Host $off
Write-Host ($on + ('='*64)) -NoNewline; Write-Host $off

& (Join-Path $Here 'Emit-CoPongReceipt.ps1') @PSBoundParameters -OneLine

