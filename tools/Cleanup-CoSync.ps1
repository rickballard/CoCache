$ErrorActionPreference="Stop"
$CC = Join-Path $HOME "Documents\GitHub\CoCache"
# delete bloat reports older than 30 days
Get-ChildItem (Join-Path $CC "status") -Filter "cosync_bloat_*" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | Remove-Item -Force -ErrorAction SilentlyContinue
# keep last 200 heartbeat lines
$hb = Join-Path $CC "status\heartbeats.md"
if(Test-Path $hb){ (Get-Content $hb -Tail 200) | Set-Content -Encoding UTF8 $hb }
# keep last 10 days of receipts
$logDir = Join-Path $CC "status\log"
if(Test-Path $logDir){
  Get-ChildItem $logDir -Filter "cosync_*.jsonl" | Where-Object {
    $_.BaseName -match '^cosync_(\d{8})$' -and [datetime]::ParseExact($Matches[1],'yyyyMMdd',$null) -lt (Get-Date).AddDays(-10)
  } | Remove-Item -Force -ErrorAction SilentlyContinue
}
