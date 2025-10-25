param([string]$Root = (Join-Path $HOME "Documents\GitHub\CoCache"))
$ErrorActionPreference='Stop'
$logDir   = Join-Path $Root 'status\log'
$intent   = Join-Path $Root 'docs\intent'; New-Item -ItemType Directory -Force -Path $intent | Out-Null
$indexMd  = Join-Path $intent 'SESSION_INDEX.md'

function San([string]$s){ if(-not $s){ return '' }; return ($s -replace '\|','\|') }

$objs = @()
$files = @(Get-ChildItem $logDir -Filter 'cosync_*.jsonl' -File -ErrorAction SilentlyContinue | Sort-Object Name)
foreach($f in $files){
  foreach($line in (Get-Content -LiteralPath $f.FullName -ErrorAction SilentlyContinue)){
    $t=$line.Trim(); if(-not $t){ continue }
    try { $o = $t | ConvertFrom-Json -ErrorAction Stop } catch { continue }
    $dt = $null; try { $dt=[DateTime]::Parse($o.when,$null,[System.Globalization.DateTimeStyles]::RoundtripKind) } catch {}
    $objs += [pscustomobject]@{
      when=$dt
      date= if($dt){ $dt.ToString('yyyy-MM-dd HH:mm') } else { '' }
      repo=$o.repo; area=$o.area; type=$o.type; summary=$o.summary
      links=@(
        if($o.data -and $o.data.handoff_md){ "handoff: $($o.data.handoff_md)" }
        if($o.data -and $o.data.plan){ "plan: $($o.data.plan)" }
        if($o.data -and $o.data.start){ "start: $($o.data.start)" }
      ) -join ' • '
    }
  }
}

# include any standalone plan/handoff docs not referenced by receipts
$handDocs = @(Get-ChildItem (Join-Path $intent '*.md') -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'session_handoff|SESSION_PLAN' })
foreach($h in $handDocs){
  if(-not ($objs | Where-Object { ($_.links ?? '') -match [regex]::Escape($h.Name) })){
    $objs += [pscustomobject]@{
      when=$null; date=''; repo='CoCache'; area='intent'; type='note'
      summary=$h.Name; links=$h.FullName.Replace($Root+'\','')
    }
  }
}

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("# SESSION_INDEX (auto-built)")
[void]$sb.AppendLine("**Generated (UTC):** " + ([DateTime]::UtcNow.ToString('u')))
[void]$sb.AppendLine("")

if(-not $objs.Count){
  [void]$sb.AppendLine("_No receipts found yet. This file will populate as CoSync emits._")
} else {
  $objs = $objs | Sort-Object when -Descending
  $latestPlan    = $objs | Where-Object { $_.type -eq 'plan' -or $_.area -eq 'plan' -or $_.summary -match 'SESSION_PLAN' } | Select-Object -First 1
  $latestHandoff = $objs | Where-Object { $_.area -eq 'handoff' -or $_.type -eq 'handoff' -or $_.summary -match 'session handoff' } | Select-Object -First 1
  if($latestPlan){    [void]$sb.AppendLine("- Latest plan: "    + (San($latestPlan.links)  ?? San($latestPlan.summary))) }
  if($latestHandoff){ [void]$sb.AppendLine("- Latest handoff: " + (San($latestHandoff.links)?? San($latestHandoff.summary))) }
  [void]$sb.AppendLine("")
  $byArea = $objs | Group-Object area
  foreach($g in $byArea){
    [void]$sb.AppendLine("## " + (San($g.Name) ?? '(unknown)'))
    [void]$sb.AppendLine("| when (UTC) | repo | type | summary | links |")
    [void]$sb.AppendLine("|---|---|---|---|---|")
    foreach($r in $g.Group | Select-Object -First 50){
      $date = San($r.date); $repo=San($r.repo); $type=San($r.type); $summary=San($r.summary); $links=San($r.links)
      [void]$sb.AppendLine("| $date | $repo | $type | $summary | $links |")
    }
    [void]$sb.AppendLine("")
  }
}

$sb.ToString() | Set-Content -Encoding UTF8 -LiteralPath $indexMd
Write-Host "✔ index written: $indexMd"
