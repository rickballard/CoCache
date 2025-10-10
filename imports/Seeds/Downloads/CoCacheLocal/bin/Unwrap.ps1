param([string]$Agent = "U")
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$CCL = $env:COCACHE_LOCAL ?? (Join-Path $HOME "Downloads/CoCacheLocal")
$dl  = $env:COCACHE_DOWNLOADS ?? (Join-Path $HOME "Downloads")
$inbox = Join-Path $CCL "inbox"; $archive = Join-Path $CCL "archive"
New-Item -Type Directory -Force -Path $inbox,$archive | Out-Null
$me = $env:COSESSION_ID
function _IsAddressed([string]$name,[string]$me){ ($name -like "*-to-$me.zip" -or $name -like "*-to-ANY.zip") }

$pick = $null
$latestPath = Join-Path $dl 'CoWrap.latest.json'
if (Test-Path $latestPath) {
  try { $lp = Get-Content $latestPath -Raw | ConvertFrom-Json
        if ($lp.zip_path) {
          $cand = Get-Item -LiteralPath $lp.zip_path -ErrorAction SilentlyContinue
          if ($cand -and $cand.Exists -and $cand.Name -notlike 'CoWrap_DELETABLE-*' -and (_IsAddressed $cand.Name $me)) { $pick = $cand }
        } } catch {}
}
if (-not $pick) {
  $zips = Get-ChildItem $dl -Filter 'CoWrap*.zip' -ErrorAction SilentlyContinue |
          Where-Object { $_.Name -notlike 'CoWrap_DELETABLE-*' } |
          Sort-Object LastWriteTime -Descending
  if (-not $zips) { Write-Warning "No unhandled CoWrap*.zip found in $dl"; return }
  $pick = $zips | Where-Object { $_.Name -like "*-to-$me.zip" } | Select-Object -First 1
  if (-not $pick) { $pick = $zips | Where-Object { $_.Name -like "*-to-ANY.zip" } | Select-Object -First 1 }
  if (-not $pick) { $pick = $zips | Select-Object -First 1 }
}

$dest = Join-Path $inbox ([System.IO.Path]::GetFileNameWithoutExtension($pick.Name))
if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
Expand-Archive -Path $pick.FullName -DestinationPath $dest -Force

$hand = Join-Path $dest 'handover.json'
$repo='(unknown)'; $branch='(unknown)'; $dirty=0; $from='(unknown)'; $when='(unknown)'
if (Test-Path $hand) {
  $ho = Get-Content $hand -Raw | ConvertFrom-Json
  $from = $ho.session_id; $when=$ho.ts; $repo=$ho.repo; $branch=$ho.branch
  $status=@($ho.status); $dirty=($status | Where-Object { $_ -match '^(?:\?\?| M|M |A |D |R |C |UU|AM|MM| T)' }).Count
}

$deletableName = 'CoWrap_DELETABLE-' + $pick.Name
$deletablePath = Join-Path $dl $deletableName
if (Test-Path $deletablePath) { Remove-Item -Force $deletablePath }
Rename-Item -Path $pick.FullName -NewName $deletableName
$archZip = Join-Path $archive $deletableName
Copy-Item -Force $deletablePath $archZip

$receipt = [ordered]@{ kind='CoUnwrap'; consumed_utc=(Get-Date).ToUniversalTime().ToString('o'); for_session=$me; from_session=$from; src_zip=$deletablePath; archived_copy=$archZip; dest_path=$dest }
try { Import-Module (Join-Path $HOME "Downloads\CoCacheLocal\bin\BPOE.Status.psm1") -ErrorAction Stop } catch {}
try { $receipt["bloat_at_unwrap"] = Get-BPOEBloatIndex } catch {}
( $receipt | ConvertTo-Json -Depth 6 ) | Set-Content -Encoding UTF8NoBOM (Join-Path $dl ("CoUnwrap.Receipt-$me.json"))

$emit = Join-Path $CCL 'bin\Emit.ps1'; if (Test-Path $emit) { & $emit -Agent $Agent -Type 'unwrap' -Msg "unwrapped and marked $($deletableName)" -Data @{ src=$deletablePath; dest=$dest; from=$from } | Out-Null }

Write-Host "=== CoUnWrap ==="
Write-Host ("From     : {0}" -f $from)
Write-Host ("When(UTC): {0}" -f $when)
Write-Host ("Repo     : {0}" -f $repo)
Write-Host ("Branch   : {0}" -f $branch)
Write-Host ("Dirty    : {0} change(s)" -f $dirty)
Write-Host ("Unpacked : {0}" -f $dest)
Write-Host ("Zip→Marked (delete me): {0}" -f $deletablePath)
Write-Host ("Archived copy: {0}" -f $archZip)
Write-Host "NEXT: cd `"$repo`" ; git status -sb"

