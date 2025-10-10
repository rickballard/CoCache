# Ensure-InboxWatcher.ps1
[CmdletBinding()]
param([string]$Inbox,[string]$ToTag,[switch]$VerboseLog)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
$CO_TEMP = if ($env:CO_TEMP) { $env:CO_TEMP } else { Join-Path $HOME 'Downloads\CoTemp' }
$Inbox   = if ($Inbox) { $Inbox } else { Join-Path $CO_TEMP 'inbox' }
$ToTag   = if ($ToTag) { $ToTag } elseif ($env:CO_TAG) { $env:CO_TAG } else { 'gmig' }
New-Item -ItemType Directory -Force -Path $CO_TEMP, $Inbox, (Join-Path $CO_TEMP 'logs') | Out-Null
$candidateRoots = @(
  Join-Path $HOME 'Documents\GitHub\CoCache\scripts',
  Join-Path $HOME 'Documents\GitHub\CoAgent\scripts',
  Join-Path $HOME 'Documents\GitHub',
  $PSScriptRoot
) | Where-Object { Test-Path $_ }
$watcher = $null
foreach ($root in $candidateRoots) {
  $found = Get-ChildItem -Path $root -Filter Start-CoInboxWatcher.ps1 -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($found) { $watcher = $found.FullName; break }
}
if (-not $watcher) {
  Write-Warning "Start-CoInboxWatcher.ps1 not found."
} else {
  & $watcher -Inbox $Inbox -ToTag $ToTag
}
$log = Join-Path $CO_TEMP ('logs\panel-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.log')
$meta = "ts={0} inbox={1} tag={2} chat_url={3} watcher={4}" -f (Get-Date).ToString('o'), $Inbox, $ToTag, $env:CO_CHAT_URL, $watcher
Add-Content -Path $log -Value $meta
if ($VerboseLog) { Write-Host $meta }
