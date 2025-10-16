param([switch]$Autofix,[int]$DaysBeforePurge=30)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest

# 1) LFS/size guard
$oversize = git ls-files -z | % { $_ -replace "`0","" } |
  % { [pscustomobject]@{Path=$_;Bytes=(Get-Item $_ -EA SilentlyContinue).Length} } |
  ? { $_.Bytes -gt 1MB -and (param([switch]$Autofix,[int]$DaysBeforePurge=30)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest

# 1) LFS/size guard
$oversize = git ls-files -z | % { $_ -replace "`0","" } |
  % { [pscustomobject]@{Path=$_;Bytes=(Get-Item $_ -EA SilentlyContinue).Length} } |
  ? { $_.Bytes -gt 1MB -and ($_..Path -notmatch '\.gitattributes|^\.git/') -and ($_..Path -notmatch '\.zip$') }  # adjust
if($oversize){ Write-Host "Oversize (not LFS):"; $oversize | ft -a }

# 2) Move obvious stale scripts to ops/_deprecated/YYYY-MM
$bucket = ("ops/_deprecated/{0}" -f (Get-Date -Format 'yyyy-MM')); New-Item -ItemType Directory -Force $bucket | Out-Null
$stale = @()
$stale += Get-ChildItem ops -Recurse -Include *.ps1,*.sh,*.cmd | ? { $_.FullName -notmatch '_deprecated' } |
  ? { -not (git grep -n -I ([regex]::Escape($_.Name)) 2>$null) }
if($Autofix -and $stale){
  $stale | % { Move-Item $_.FullName (Join-Path $bucket $_.Name) -Force }
}

# 3) Purge anything in _deprecated older than window
$old = Get-ChildItem ops/_deprecated -Recurse -File -EA SilentlyContinue |
  ? { $_.LastWriteTimeUtc -lt (Get-Date).AddDays(-$DaysBeforePurge) }
if($Autofix -and $old){ $old | Remove-Item -Force }

# 4) Write a tiny report (committed by workflow if changed)
New-Item -ItemType Directory -Force admin/reports | Out-Null
$ts=(Get-Date).ToString('s')
$rep="admin/reports/hygiene_$($ts.Replace(':','-')).txt"
@(
  "== Hygiene @ $ts ==",
  "",
  "Oversize:", ($oversize|%{"  {0} ({1:n0} bytes)" -f $_.Path,$_.Bytes}),
  "",
  "Staged stale -> _deprecated:", ($stale|%{"  " + $_.FullName}),
  "",
  "Purged old:", ($old|%{"  " + $_.FullName})
) -join "`r`n" | Set-Content -Encoding UTF8 $rep
.Path -notmatch '\.gitattributes|^\.git/') -and (param([switch]$Autofix,[int]$DaysBeforePurge=30)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest

# 1) LFS/size guard
$oversize = git ls-files -z | % { $_ -replace "`0","" } |
  % { [pscustomobject]@{Path=$_;Bytes=(Get-Item $_ -EA SilentlyContinue).Length} } |
  ? { $_.Bytes -gt 1MB -and ($_..Path -notmatch '\.gitattributes|^\.git/') -and ($_..Path -notmatch '\.zip$') }  # adjust
if($oversize){ Write-Host "Oversize (not LFS):"; $oversize | ft -a }

# 2) Move obvious stale scripts to ops/_deprecated/YYYY-MM
$bucket = ("ops/_deprecated/{0}" -f (Get-Date -Format 'yyyy-MM')); New-Item -ItemType Directory -Force $bucket | Out-Null
$stale = @()
$stale += Get-ChildItem ops -Recurse -Include *.ps1,*.sh,*.cmd | ? { $_.FullName -notmatch '_deprecated' } |
  ? { -not (git grep -n -I ([regex]::Escape($_.Name)) 2>$null) }
if($Autofix -and $stale){
  $stale | % { Move-Item $_.FullName (Join-Path $bucket $_.Name) -Force }
}

# 3) Purge anything in _deprecated older than window
$old = Get-ChildItem ops/_deprecated -Recurse -File -EA SilentlyContinue |
  ? { $_.LastWriteTimeUtc -lt (Get-Date).AddDays(-$DaysBeforePurge) }
if($Autofix -and $old){ $old | Remove-Item -Force }

# 4) Write a tiny report (committed by workflow if changed)
New-Item -ItemType Directory -Force admin/reports | Out-Null
$ts=(Get-Date).ToString('s')
$rep="admin/reports/hygiene_$($ts.Replace(':','-')).txt"
@(
  "== Hygiene @ $ts ==",
  "",
  "Oversize:", ($oversize|%{"  {0} ({1:n0} bytes)" -f $_.Path,$_.Bytes}),
  "",
  "Staged stale -> _deprecated:", ($stale|%{"  " + $_.FullName}),
  "",
  "Purged old:", ($old|%{"  " + $_.FullName})
) -join "`r`n" | Set-Content -Encoding UTF8 $rep
.Path -notmatch '\.zip$') }  # adjust
if($oversize){ Write-Host "Oversize (not LFS):"; $oversize | ft -a }

# 2) Move obvious stale scripts to ops/_deprecated/YYYY-MM
$bucket = ("ops/_deprecated/{0}" -f (Get-Date -Format 'yyyy-MM')); New-Item -ItemType Directory -Force $bucket | Out-Null
$stale = @()
$stale += Get-ChildItem ops -Recurse -Include *.ps1,*.sh,*.cmd | ? { $_.FullName -notmatch '_deprecated' } |
  ? { -not (git grep -n -I ([regex]::Escape($_.Name)) 2>$null) }
if($Autofix -and $stale){
  $stale | % { Move-Item $_.FullName (Join-Path $bucket $_.Name) -Force }
}

# 3) Purge anything in _deprecated older than window
$old = Get-ChildItem ops/_deprecated -Recurse -File -EA SilentlyContinue |
  ? { $_.LastWriteTimeUtc -lt (Get-Date).AddDays(-$DaysBeforePurge) }
if($Autofix -and $old){ $old | Remove-Item -Force }

# 4) Write a tiny report (committed by workflow if changed)
New-Item -ItemType Directory -Force admin/reports | Out-Null
$ts=(Get-Date).ToString('s')
$rep="admin/reports/hygiene_$($ts.Replace(':','-')).txt"
@(
  "== Hygiene @ $ts ==",
  "",
  "Oversize:", ($oversize|%{"  {0} ({1:n0} bytes)" -f $_.Path,$_.Bytes}),
  "",
  "Staged stale -> _deprecated:", ($stale|%{"  " + $_.FullName}),
  "",
  "Purged old:", ($old|%{"  " + $_.FullName})
) -join "`r`n" | Set-Content -Encoding UTF8 $rep

