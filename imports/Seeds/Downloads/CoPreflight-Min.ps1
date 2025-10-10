# Read-only health check; logs to Downloads; no profile/module edits
$ErrorActionPreference='SilentlyContinue'
$log = Join-Path ([Environment]::GetFolderPath('UserProfile')) "Downloads\BPOE_Preflight_Log.txt"
$lines = @()
$lines += ""
$lines += "## BPOE Preflight (minimal) — $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')"
# Exit hook present?
$ex = Get-EventSubscriber -SourceIdentifier PowerShell.Exiting -ErrorAction SilentlyContinue
$lines += "- Exit hook: " + ($(if($ex){"OK"}else{"MISSING"}))
# OE timers/jobs?
$evt = Get-EventSubscriber -SourceIdentifier OEStatusTimer -ErrorAction SilentlyContinue
$job = Get-Job -Name OEStatusTimer -ErrorAction SilentlyContinue
$lines += "- OEStatusTimer: " + ($(if($evt -or $job){"PRESENT (unexpected)"}else{"none"}))
# Crash sentinel?
$sentinel = Join-Path $env:LOCALAPPDATA 'CoBPOE\session.sentinel'
$lines += "- Crash sentinel file: " + ($(Test-Path $sentinel))
# Profile parsable?
if (Test-Path $PROFILE) {
  $t=[System.Management.Automation.Language.Token[]]$null
  $e=[System.Management.Automation.Language.ParseError[]]$null
  [System.Management.Automation.Language.Parser]::ParseFile($PROFILE,[ref]$t,[ref]$e) | Out-Null
  $lines += "- Profile AST: " + ($(if($e -and $e.Count){'ERROR'}else{'OK'}))
} else {
  $lines += "- Profile: missing (OK)"
}
# Write log
try {
  Add-Content -LiteralPath $log -Encoding UTF8 -Value ([string]::Join([Environment]::NewLine,$lines))
  Write-Host "[CoPreflight-Min] Logged to $log" -ForegroundColor Cyan
} catch { Write-Host "[CoPreflight-Min] Could not write log: $($_.Exception.Message)" -ForegroundColor Yellow }