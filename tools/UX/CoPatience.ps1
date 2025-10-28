# CoPatience.ps1 — non-blocking "second dots" status row for long-running tasks
# Usage:
#   . tools/UX/CoPatience.ps1
#   $pat = Start-CoPatience -Message "Working" -IntervalSec 1 -MaxDots 60
#   try { Start-Sleep 3 } finally { Stop-CoPatience -State $pat -DoneMessage "Done" }

Set-StrictMode -Version Latest

function Start-CoPatience {
  [CmdletBinding()]
  param(
    [string]$Message = "Please wait",
    [int]$IntervalSec = 1,
    [int]$MaxDots = 60,
    [switch]$Quiet
  )
  $IntervalSec = [Math]::Max(1,$IntervalSec)
  $MaxDots     = [Math]::Max(3,$MaxDots)

  $state = [ordered]@{
    Timer      = $null
    Dots       = 0
    MaxDots    = $MaxDots
    Message    = $Message
    LinePrefix = " … "
    Active     = $true
  }

  if (-not $Quiet) { Write-Host "Press Ctrl+C to cancel (if supported)"; }
  Write-Host ""
  $global:__CoPatience_LastCursor = $Host.UI.RawUI.CursorPosition

  $write = {
    param($s)
    try {
      $ui = $Host.UI.RawUI
      $cur = $ui.CursorPosition
      $ui.CursorPosition = $global:__CoPatience_LastCursor
      $dots = "." * $s.Dots
      $line = ("{0}{1} {2}" -f $s.LinePrefix, $s.Message, $dots)
      $width = $ui.WindowSize.Width
      Write-Host ($line + (" " * [Math]::Max(0,$width - $line.Length - 1))) -NoNewline
      $ui.CursorPosition = $cur
    } catch { }
  }

  $timer = [System.Timers.Timer]::new($IntervalSec * 1000)
  $timer.AutoReset = $true
  $null = $timer.add_Elapsed({
    if (-not $state.Active) { return }
    $state.Dots = ($state.Dots + 1)
    if ($state.Dots -gt $state.MaxDots) { $state.Dots = 1 }
    & $write $state
  })
  $timer.Start()
  $state.Timer = $timer

  $state.Dots = 1
  & $write $state
  return $state
}

function Stop-CoPatience {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)] $State,
    [string]$DoneMessage = "Done"
  )
  try {
    if ($State -and $State.Timer) {
      $State.Active = $false
      $State.Timer.Stop(); $State.Timer.Dispose()
    }
  } catch {}
  try {
    $ui = $Host.UI.RawUI
    $cur = $ui.CursorPosition
    $ui.CursorPosition = $global:__CoPatience_LastCursor
    Write-Host ("{0}{1} ✓" -f $State.LinePrefix, $DoneMessage).PadRight($ui.WindowSize.Width-1)
    $ui.CursorPosition = $cur
  } catch {
    Write-Host " $DoneMessage"
  }
}

Export-ModuleMember -Function Start-CoPatience, Stop-CoPatience
