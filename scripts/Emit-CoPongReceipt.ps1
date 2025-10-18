$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
param(
  [string]$SessionId, [string]$CycleId, [int]$Attempt=1, [string]$Status='ready',
  [string]$RepoName='CoCache', [string]$Branch='main',
  [string]$Prev='-', [string]$NewSha='',
  [string]$LinesUp='', [string]$LinesDown='',
  [ValidateSet('violet','orange')] [string]$Theme='violet'
)
if(-not $NewSha){ $NewSha = (git rev-parse --short HEAD) }
$esc=[char]27; $supportsVT = $Host.Name -ne 'ConsoleHost' -or $PSStyle.OutputRendering -ne 'PlainText'
$color = if($Theme -eq 'orange'){ '38;5;208' } else { '38;5;135' }
$on = $supportsVT ? "$esc[$color" + "m" : ''
$off = $supportsVT ? "$esc[0m" : ''

$plain = @"
===== CoPONG RECEIPT BEGIN =====
session_id: $SessionId  cycle_id: $CycleId  attempt: $Attempt  status: $Status
commit: prev $Prev -> new $NewSha  repo: $RepoName  branch: $Branch
$LinesUp
$LinesDown
TTL: 3d
===== CoPONG RECEIPT END =====
"@.Trim()

Write-Host ""
Write-Host ($on + ('='*64)) -NoNewline; Write-Host $off
Write-Host ($on + "   CoPONG RECEIPT  ($SessionId/$CycleId  $Status)   ") -NoNewline; Write-Host $off
Write-Host ($on + ('='*64)) -NoNewline; Write-Host $off
Write-Host ""
$plain | Write-Output
Write-Host ""
