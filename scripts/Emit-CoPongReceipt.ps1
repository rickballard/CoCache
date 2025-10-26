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
  [ValidateSet('violet','orange')] [string]$Theme = 'violet',
  [switch]$OneLine
)

$ErrorActionPreference = 'Stop'; Set-StrictMode -Version Latest

# --- Resolve commit + branch if callers omitted them
try {
  if (-not $NewSha) { $NewSha = (git rev-parse --short HEAD) }
  if (-not $Branch) { $Branch = (git rev-parse --abbrev-ref HEAD) }
} catch { }

# --- Remote probe (accurate push/PR status)
try {
  $localFull = (git rev-parse HEAD)               ; $localShort = $localFull.Substring(0,7)
  $remoteRef = "refs/heads/$Branch"
  $remoteSha = (git ls-remote origin $remoteRef | Select-String '^\S+' | ForEach-Object { $_.Matches[0].Value })
  if ([string]::IsNullOrWhiteSpace($remoteSha)) {
    $RemoteStatus = 'needs-PR'
  } elseif ($remoteSha.Substring(0,7) -eq $localShort) {
    $RemoteStatus = 'pushed'
  } else {
    $counts = (git rev-list --left-right --count origin/$Branch...$Branch 2>$null) -split '\s+'
    if ($counts.Count -ge 2 -and [int]$counts[1] -gt 0) { $RemoteStatus = 'ahead-unpushed' } else { $RemoteStatus = 'diverged' }
  }
} catch { $RemoteStatus = 'unknown' }

# --- ANSI theme
$esc = [char]27
$supportsVT = $Host.Name -ne 'ConsoleHost' -or $PSStyle.OutputRendering -ne 'PlainText'
$color = if ($Theme -eq 'orange') { '38;5;208' } else { '38;5;135' }
$on  = $supportsVT ? "$esc[$color" + "m" : ''
$off = $supportsVT ? "$esc[0m" : ''

# --- Outputs
$plain = @"
===== CoPONG RECEIPT BEGIN =====
session_id: $SessionId  cycle_id: $CycleId  attempt: $Attempt  status: $Status
commit: prev $Prev -> new $NewSha  repo: $RepoName  branch: $Branch  remote: $RemoteStatus
$LinesUp
$LinesDown
TTL: 3d
===== CoPONG RECEIPT END =====
"@.Trim()

if ($OneLine) {
  $compact = ("# CoPONG:" +
    " session_id=$SessionId" +
    " cycle_id=$CycleId" +
    " attempt=$Attempt" +
    " status=$Status" +
    " remote=$RemoteStatus" +
    " commit_prev=$Prev" +
    " commit_new=$NewSha" +
    " repo=$RepoName" +
    " branch=$Branch" +
    " " + ($LinesUp   -replace "`n",' ') +
    " " + ($LinesDown -replace "`n",' ')
  ).Trim()
  Write-Host ""
  Write-Output $compact
  Write-Host ""
} else {
  Write-Host ""
  Write-Host ($on + ('='*64)) -NoNewline; Write-Host $off
  Write-Host ($on + "   CoPONG RECEIPT  ($SessionId/$CycleId  $Status)   ") -NoNewline; Write-Host $off
  Write-Host ($on + ('='*64)) -NoNewline; Write-Host $off
  Write-Host ""
  $plain | Write-Output
  Write-Host ""
}



