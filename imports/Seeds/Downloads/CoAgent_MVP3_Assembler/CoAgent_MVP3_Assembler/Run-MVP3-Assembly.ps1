param(
  [switch]$Commit,
  [switch]$Push
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$Packs      = Join-Path $ScriptRoot 'packs'
$Logs       = Join-Path $ScriptRoot 'logs'
$RunLog     = Join-Path $Logs ("run-{0}.log" -f (Get-Date -Format 'yyyyMMdd-HHmmss'))

if(-not (Test-Path $Packs)){ throw "Missing packs folder: $Packs" }
New-Item -ItemType Directory -Force -Path $Logs | Out-Null

function Note([string]$m){ Write-Host ("[MVP3] " + $m) }
function LogLine([string]$m){ $m | Out-File -FilePath $RunLog -Append -Encoding UTF8 }

Note "Starting assembly…"
LogLine ("# Run at " + (Get-Date).ToString('s'))

$packFiles = Get-ChildItem (Join-Path $Packs '*.ps1') -File | Sort-Object Name

foreach($pf in $packFiles){
  $name = $pf.Name
  Note ("Running " + $name)
  LogLine ("> " + $name)
  try{
    & $pf.FullName @PSBoundParameters
    Note ("OK  " + $name)
    LogLine ("OK  " + $name)
  }catch{
    $msg = $_.Exception.Message
    Write-Host ("[MVP3] FAIL " + $name + " :: " + $msg) -ForegroundColor Red
    LogLine ("FAIL " + $name + " :: " + $msg)
    throw
  }
}

Note "Assembly complete."
LogLine "DONE"
