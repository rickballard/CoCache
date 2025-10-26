param(
  [string]$LogDir = (Join-Path (Join-Path $HOME "Documents\GitHub\CoCache") "status\log"),
  [string]$OutCsv = (Join-Path (Join-Path $HOME "Documents\GitHub\CoCache") "docs\dashboards\cosync_validation.csv"),
  [string]$GapMd  = (Join-Path (Join-Path $HOME "Documents\GitHub\CoCache") "docs\intent\COSYNC_GAPS.md")
)
$ErrorActionPreference='Stop'
$allowedTypes = @('progress','alert','note','error','handoff','intent','housekeeping','plan')
$rows = @()
$errors = @()

$files = Get-ChildItem $LogDir -Filter 'cosync_*.jsonl' -File -ErrorAction SilentlyContinue | Sort-Object Name
foreach($f in $files){
  $i=0
  foreach($line in Get-Content -LiteralPath $f.FullName -ErrorAction SilentlyContinue){
    $i++
    $t = $line.Trim(); if(-not $t){ continue }
    try {
      $o = $t | ConvertFrom-Json -ErrorAction Stop
      $whenOK = $false
      try { [void][DateTime]::Parse($o.when,$null,[System.Globalization.DateTimeStyles]::RoundtripKind); $whenOK=$true } catch {}
      $typeOK = $allowedTypes -contains ($o.type ?? '').ToString().ToLowerInvariant()
      $summaryOK = [bool]($o.summary) -and ($o.summary.ToString().Trim().Length -gt 0)
      $dataOK = ($o.data -ne $null) -and ($o.data.GetType().Name -match 'Hashtable|Dictionary|PSCustomObject')
      # identity: optional overall, but if present must have shape
      $idErr=@()
      if($o.user){ if(($o.user.anon -isnot [bool])){ $idErr+='user.anon missing/bool' } }
      if($o.actor){ if(-not $o.actor.type){ $idErr+='actor.type missing' } if(-not $o.actor.name){ $idErr+='actor.name missing' } }
      if($o.session){ if(-not $o.session.role){ $idErr+='session.role missing' } }
      $ok = $whenOK -and $typeOK -and $summaryOK -and $dataOK -and ($idErr.Count -eq 0)

      if(-not $ok){
        $msg = @()
        if(-not $whenOK){   $msg += 'when invalid/blank' }
        if(-not $typeOK){   $msg += "type invalid (got '$($o.type)')" }
        if(-not $summaryOK){$msg += 'summary blank' }
        if(-not $dataOK){   $msg += 'data not object' }
        if($idErr.Count){   $msg += ('identity: ' + ($idErr -join '; ')) }
        $errors += [pscustomobject]@{ file=$f.Name; line=$i; repo=$o.repo; area=$o.area; type=$o.type; summary=$o.summary; problem=($msg -join ' | ') }
      }

      $rows += [pscustomobject]@{
        file=$f.Name; line=$i; repo=$o.repo; area=$o.area; type=$o.type; ok=$ok
        when=$o.when; summary=$o.summary
      }
    } catch {
      $errors += [pscustomobject]@{ file=$f.Name; line=$i; repo='?'; area='?'; type='?'; summary='(parse failed)'; problem=$_.Exception.Message }
    }
  }
}

$rows | Sort-Object file,line | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $OutCsv

# Write a friendly gap report
$md = New-Object System.Text.StringBuilder
[void]$md.AppendLine("# CoSync Validation — Gaps")
[void]$md.AppendLine("")
if($errors.Count){
  [void]$md.AppendLine("**Found $($errors.Count) issue(s).** Fix these to keep handoffs lossless.")
  [void]$md.AppendLine("")
  [void]$md.AppendLine("| file | line | repo | area | type | problem |")
  [void]$md.AppendLine("|---|---:|---|---|---|---|")
  foreach($e in $errors | Select-Object file,line,repo,area,type,problem){
    [void]$md.AppendLine("| $($e.file) | $($e.line) | $($e.repo) | $($e.area) | $($e.type) | $([string]$e.problem).Replace('|','\|') |")
  }
} else {
  [void]$md.AppendLine("✅ No validation gaps found.")
}
$md.ToString() | Set-Content -Encoding UTF8 -LiteralPath $GapMd

if($errors.Count){ Write-Host "❌ validation failures: $($errors.Count)"; exit 1 } else { Write-Host "✅ validation passed" }


# --- ABSOLUTE-URL-REQUIRED: if a data key exists, *_abs_blob and *_abs_raw must be valid URLs ---
function Test-AbsUrl([string]$u){ return ($u -match '^https?://') }
$absKeys = @('handoff_md','plan','start','index','gaps','csv')
if($o.PSObject.Properties.Name -contains 'data' -and $o.data){
  foreach($k in $absKeys){
    if($o.data.PSObject.Properties.Name -contains $k){
      $blobKey = "${k}_abs_blob"
      $rawKey  = "${k}_abs_raw"
      $blobOk = ($o.data.PSObject.Properties.Name -contains $blobKey) -and (Test-AbsUrl([string]$o.data.$blobKey))
      $rawOk  = ($o.data.PSObject.Properties.Name -contains $rawKey)  -and (Test-AbsUrl([string]$o.data.$rawKey))
      if(-not ($blobOk -and $rawOk)){
        $errors += [pscustomobject]@{
          file=$f.Name; line=$i; repo=$o.repo; area=$o.area; type=$o.type; summary=$o.summary
          problem=("absolute URL companions missing/invalid for '$k' (need ${blobKey} and ${rawKey})")
        }
      }
    }
  }
}

