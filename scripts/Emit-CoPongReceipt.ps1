
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
param(
  [string]$SessionId, [string]$CycleId, [int]$Attempt=1, [string]$Status='ready',
  [string]$RepoName='(unknown)', [string]$Branch='',
  [string]$Prev='-', [string]$NewSha='',
  [string]$LinesUp='', [string]$LinesDown='',
  [ValidateSet('violet','orange')] [string]$Theme='violet',
  [switch]$OneLine
)
if(-not $NewSha){ try { $NewSha = (git rev-parse --short HEAD) } catch { $NewSha='-' } }

# --- Remote probe (accurate status) ---
try {
  if(-not $Branch){ $Branch = (git rev-parse --abbrev-ref HEAD) }
  $localFull = (git rev-parse HEAD)
  $localSha  = if($localFull){ $localFull.Substring(0,7) } else { '-' }
  $remoteRef = "refs/heads/$Branch"
  $remoteSha = (git ls-remote origin $remoteRef | Select-String -Pattern "^\S+" | ForEach-Object { $_.Matches[0].Value })
  if([string]::IsNullOrWhiteSpace($remoteSha)){
    $RemoteStatus = "needs-PR"
  } elseif($remoteSha.Substring(0,7) -eq $localSha){
    $RemoteStatus = "pushed"
  } else {
    $ahead = (git rev-list --left-right --count origin/$Branch...$Branch 2>$null) -split '\s+'
    if($ahead.Count -ge 2 -and [int]$ahead[1] -gt 0){ $RemoteStatus = "ahead-unpushed" } else { $RemoteStatus = "diverged" }
  }
} catch { $RemoteStatus = "unknown" }

# --- Colored header controls ---
$esc=[char]27; $supportsVT = $Host.Name -ne 'ConsoleHost' -or $PSStyle.OutputRendering -ne 'PlainText'
$color = if($Theme -eq 'orange'){ '38;5;208' } else { '38;5;135' }
$on = $supportsVT ? "$esc[$color" + "m" : ''
$off = $supportsVT ? "$esc[0m" : ''

# --- Output ---
if($OneLine){
  $compact = ("# CoPONG:" +
    " session_id=" + $SessionId +
    " cycle_id="   + $CycleId +
    " attempt="    + $Attempt +
    " status="     + $Status +
    " remote="     + $RemoteStatus +
    " commit_prev=" + $Prev +
    " commit_new="  + $NewSha +
    " repo="        + $RepoName +
    " branch="      + $Branch +
    " " + ($LinesUp -replace "`n"," ") +
    " " + ($LinesDown -replace "`n"," ")
  ).Trim()
  Write-Host ""
  Write-Output $compact
  Write-Host ""
} else {
  $plain = @"
===== CoPONG RECEIPT BEGIN =====
session_id: $SessionId  cycle_id: $CycleId  attempt: $Attempt  status: $Status  remote: $RemoteStatus
commit: prev $Prev -> new $NewSha  repo: $RepoName  branch: $Branch
$LinesUp
$LinesDown
TTL: 3d
===== CoPONG RECEIPT END =====
"@.Trim()

  Write-Host ""
  Write-Host ($on + ('='*64)) -NoNewline; Write-Host $off
  Write-Host ($on + "   CoPONG RECEIPT  ($SessionId/$CycleId  $Status | $RemoteStatus)   ") -NoNewline; Write-Host $off
  Write-Host ($on + ('='*64)) -NoNewline; Write-Host $off
  Write-Host ""
  $plain | Write-Output
  Write-Host ""
}
