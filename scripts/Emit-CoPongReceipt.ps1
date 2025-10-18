[CmdletBinding()]
param(
  [string]$SessionId,
  [string]$CycleId,
  [int]$Attempt=1,
  [string]$Status='ready',
  [string]$RepoName='CoCache',
  [string]$Branch='main',
  [string]$Prev='-',
  [string]$NewSha='',
  [string]$LinesUp='',
  [string]$LinesDown='',
  [ValidateSet('violet','orange')][string]$Theme='violet',
  [switch]$OneLine
)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest

if(-not $NewSha){ $NewSha = (git rev-parse --short HEAD) }
$esc=[char]27; $supportsVT = $Host.Name -ne 'ConsoleHost' -or $PSStyle.OutputRendering -ne 'PlainText'
$color = if($Theme -eq 'orange'){ '38;5;208' } else { '38;5;135' }
$on = $supportsVT ? "$esc[$color" + "m" : ''
$off = $supportsVT ? "$esc[0m" : ''

if($OneLine){
  # Single-line, triple-click friendly
  $compact = ("# CoPONG:" +
    " session_id=" + $SessionId +
    " cycle_id="   + $CycleId +
    " attempt="    + $Attempt +
    " status="     + $Status +
    " commit_prev=" + $Prev +
    " commit_new="  + $NewSha +
    " repo="        + $RepoName +
    " branch="      + $Branch +
    " " + ($LinesUp   -replace "`r?`n"," ") +
    " " + ($LinesDown -replace "`r?`n"," ")
  ).Trim()
  Write-Host ""
  Write-Host ($on + ('='*64)) -NoNewline; Write-Host $off
  Write-Host ($on + "   CoPONG RECEIPT  ($SessionId/$CycleId  $Status)   ") -NoNewline; Write-Host $off
  Write-Host ($on + ('='*64)) -NoNewline; Write-Host $off
  Write-Host ""
  Write-Output $compact
  Write-Host ""
  return
}
# --- Remote probe (accurate status) ---
try {
  $branch = if($PSBoundParameters.ContainsKey('Branch')){ $Branch } else { (git rev-parse --abbrev-ref HEAD) }
  $localSha  = (git rev-parse HEAD).Substring(0,7)
  $remoteRef = "refs/heads/$branch"
  $remoteSha = (git ls-remote origin $remoteRef | Select-String -Pattern "^\S+" | ForEach-Object { [CmdletBinding()]
param(
  [string]$SessionId,
  [string]$CycleId,
  [int]$Attempt=1,
  [string]$Status='ready',
  [string]$RepoName='CoCache',
  [string]$Branch='main',
  [string]$Prev='-',
  [string]$NewSha='',
  [string]$LinesUp='',
  [string]$LinesDown='',
  [ValidateSet('violet','orange')][string]$Theme='violet',
  [switch]$OneLine
)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest

if(-not $NewSha){ $NewSha = (git rev-parse --short HEAD) }
$esc=[char]27; $supportsVT = $Host.Name -ne 'ConsoleHost' -or $PSStyle.OutputRendering -ne 'PlainText'
$color = if($Theme -eq 'orange'){ '38;5;208' } else { '38;5;135' }
$on = $supportsVT ? "$esc[$color" + "m" : ''
$off = $supportsVT ? "$esc[0m" : ''

if($OneLine){
  # Single-line, triple-click friendly
  $compact = ("# CoPONG:" +
    " session_id=" + $SessionId +
    " cycle_id="   + $CycleId +
    " attempt="    + $Attempt +
    " status="     + $Status +
    " commit_prev=" + $Prev +
    " commit_new="  + $NewSha +
    " repo="        + $RepoName +
    " branch="      + $Branch +
    " " + ($LinesUp   -replace "`r?`n"," ") +
    " " + ($LinesDown -replace "`r?`n"," ")
  ).Trim()
  Write-Host ""
  Write-Host ($on + ('='*64)) -NoNewline; Write-Host $off
  Write-Host ($on + "   CoPONG RECEIPT  ($SessionId/$CycleId  $Status)   ") -NoNewline; Write-Host $off
  Write-Host ($on + ('='*64)) -NoNewline; Write-Host $off
  Write-Host ""
  Write-Output $compact
  Write-Host ""
  return
}

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
.Matches[0].Value }) 
  if([string]::IsNullOrWhiteSpace($remoteSha)){
    $RemoteStatus = "needs-PR"   # remote branch missing or protected; likely local-only branch
  } elseif($remoteSha.Substring(0,7) -eq $localSha){
    $RemoteStatus = "pushed"
  } else {
    # Local and remote differ; could be ahead/behind/diverged
    $ahead = (git rev-list --left-right --count origin/$branch...$branch 2>$null) -split '\s+' 
    if($ahead.Count -ge 2 -and [int]$ahead[1] -gt 0){ $RemoteStatus = "ahead-unpushed" } else { $RemoteStatus = "diverged" }
  }
} catch { $RemoteStatus = "unknown" }
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

