param([string]$OutPath = ("admin/sessions/session_regroup_{0}.md" -f (Get-Date -Format "yyyy-MM-dd_HHmm")))
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
if(-not (Test-Path "index/va_manifest.json")){ throw "Run VA index first." }
if(-not (Test-Path "index/va_human_touch.csv")){ throw "Run human-touch first." }

$va = Get-Content index/va_manifest.json -Raw | ConvertFrom-Json
$ht = Import-Csv index/va_human_touch.csv
$cotouch = if(Test-Path "index/va_cotouch.csv"){ Import-Csv index/va_cotouch.csv } else { @() }

$total   = @($va).Count
$mdCount = @($va | ? { $_.kind -eq 'markdown' }).Count
$pdfCount= @($va | ? { $_.kind -eq 'pdf' }).Count
$zipCount= @($va | ? { $_.kind -eq 'archive' }).Count

$topTouch = $ht | Sort-Object {[int]$_.score} -Descending | Select-Object -First 50
$ts = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss zzz')

$sb = New-Object System.Text.StringBuilder
$nl = [Environment]::NewLine
$sb.AppendLine("# Session Regroup Plan") | Out-Null
$sb.AppendLine("_Generated: $($ts)_") | Out-Null
$sb.AppendLine() | Out-Null

$sb.AppendLine("## Snapshot") | Out-Null
$sb.AppendLine("* Total assets: $total  (md: $mdCount, pdf: $pdfCount, archives: $zipCount)") | Out-Null
$sb.AppendLine("* Human-touch scored: $(@($ht).Count)  | CoTouch candidates: $(@($cotouch).Count)") | Out-Null
$sb.AppendLine() | Out-Null

$sb.AppendLine("## CoTouch Top 50 (by score)") | Out-Null
foreach($r in $topTouch){
  $sb.AppendLine("- $($r.path)  (score $($r.score), commits $($r.commits), burst $($r.burst), spanDays $($r.spanDays))") | Out-Null
}
$sb.AppendLine() | Out-Null

$sb.AppendLine("## Outstanding & Inferred Directions") | Out-Null
$sb.AppendLine("- Push/PR reliability fixed; LFS healthy.") | Out-Null
$sb.AppendLine("- Megascroll delivery (glow/halo) via site; CC headers/footers stabilize.") | Out-Null
$sb.AppendLine("- CoTouch branding: tag propagation + surfaces in CC.") | Out-Null
$sb.AppendLine("- HP57 targeted packs (curate globs).") | Out-Null
$sb.AppendLine("- CoRef cross-repo index design → incremental adoption.") | Out-Null

[IO.File]::WriteAllText($OutPath,$sb.ToString(),(New-Object System.Text.UTF8Encoding($false)))
Write-Host "Wrote $OutPath" -ForegroundColor Green

