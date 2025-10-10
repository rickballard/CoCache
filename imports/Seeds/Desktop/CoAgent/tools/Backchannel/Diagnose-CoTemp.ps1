param([string]$To='co-planning')
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
$paths=@('inbox','outbox','notes','logs','panels','coticker\inbox','coticker\processed')

"[BPOE] CoTemp = $root"
"{0,-22} {1,-5} {2}" -f "PATH","EXIST","LATEST"
$paths | ForEach-Object {
  $p=Join-Path $root $_
  $latest = if(Test-Path $p){ Get-ChildItem -Force $p | Sort-Object LastWriteTime -Desc | Select -First 1 |
              ForEach-Object { '{0:u}  {1}' -f $_.LastWriteTime,$_.Name } }
  "{0,-22} {1,-5} {2}" -f $_,(Test-Path $p),$latest
}

# Write a note (watchers should consume this if they’re up)
$notes = Join-Path $root 'notes'; New-Item -ItemType Directory -Force -Path $notes | Out-Null
$evt=[ordered]@{kind='note';to=$To;from='diagnose';ts=(Get-Date -Format o);text="ping $(Get-Date -Format T)"}
$path=Join-Path $notes ("note_{0}.json" -f (Get-Date -Format 'yyyyMMdd-HHmmss'))
($evt|ConvertTo-Json -Depth 5)|Set-Content -LiteralPath $path -Encoding UTF8
"[BPOE] Wrote note -> $path"

# Ticker poke (optional)
$send="$HOME\Downloads\CoTemp\tools\CoTicker\Send-CoTickerEvent.ps1"
if(Test-Path $send){ & $send -Type block -Text ("Backchannel OK {0}" -f (Get-Date -Format T)) -Icon "✓" -Fg "LawnGreen" | Out-Null; "[BPOE] Sent CoTicker block" } else { "[BPOE] CoTicker sender not found ($send)" }
