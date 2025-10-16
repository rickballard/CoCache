function Run-WithDotsEx {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)] [ScriptBlock]$Block,
    [string]$Label = "Running",
    [int]$PredictSec = 120,
    [int]$TimeoutSec = 900,
    [int]$TenSecMark = 10,     # print ":" every TenSecMark seconds
    [int]$RowWrap = 120        # wrap line roughly to your PS7 row width
  )
  $ErrorActionPreference='Stop'; Set-StrictMode -Version Latest

  $start = Get-Date
  Write-Host ("{0} — Do not interrupt for ~{1}s (timeout {2}s)." -f $Label,$PredictSec,$TimeoutSec) -ForegroundColor Cyan

  $job = Start-Job -ScriptBlock $Block
  $sw  = [Diagnostics.Stopwatch]::StartNew()
  $sec = 0
  $inRow = 0

  try {
    while(-not (Wait-Job $job -Timeout 1)){
      $sec++
      # seconds: "."
      Write-Host -NoNewline "."
      $inRow++
      if(($sec % $TenSecMark) -eq 0){
        # 10-second marker: ":" + brief pulse
        Write-Host -NoNewline ":"
        $inRow++
        Write-Host ("  [{0}] elapsed {1}s / predicted {2}s" -f $Label,$sec,$PredictSec)
        $inRow = 0
      } elseif($inRow -ge $RowWrap){
        Write-Host ""
        $inRow = 0
      }
      if($sw.Elapsed.TotalSeconds -ge $TimeoutSec){
        Write-Host ""
        Write-Host ("Timeout after {0}s — {1}" -f $TimeoutSec,$Label) -ForegroundColor Yellow
        Stop-Job $job -ErrorAction SilentlyContinue | Out-Null
        throw "Step timed out: $Label"
      }
    }
    if($inRow -gt 0){ Write-Host "" }
    $out = Receive-Job $job -ErrorAction Stop
    if($out){ $out | Out-Host }
    Write-Host ("[DONE] {0} @ {1}" -f $Label,(Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) -ForegroundColor Green
  }
  finally {
    $sw.Stop()
    Remove-Job $job -ErrorAction SilentlyContinue | Out-Null
  }
}
