param([string]$Tag='work',[switch]$AddSharedToPath,[switch]$AddBinToPath)

$Root   = Join-Path $HOME 'Downloads/CoTemp'
$Shared = Join-Path $Root '_shared'

$env:COTEMP_ROOT   = $Root
$env:COTEMP_SHARED = $Shared

$sid = (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + $Tag + '-' + $PID
$env:COTEMP_SID     = $sid
$sessionDir         = Join-Path $env:COTEMP_ROOT ('sessions/' + $sid)
$env:COTEMP_SESSION = $sessionDir
$env:COTEMP_BIN     = Join-Path $sessionDir 'bin'
$env:COTEMP_LOG     = Join-Path $sessionDir 'logs'
$env:COTEMP_SCRATCH = Join-Path $sessionDir 'scratch'
New-Item -ItemType Directory -Force -Path $env:COTEMP_BIN,$env:COTEMP_LOG,$env:COTEMP_SCRATCH | Out-Null

# Keep .NET CurrentDirectory in sync with PowerShell location
try { $ExecutionContext.InvokeCommand.LocationChangedAction = { [Environment]::CurrentDirectory = (Get-Location).ProviderPath } } catch {}
[Environment]::CurrentDirectory = (Get-Location).ProviderPath

# Load shared helpers if present
$util = Join-Path $env:COTEMP_SHARED 'ctts-utils.ps1'
if (Test-Path $util) { . $util }

# PATH options
if ($AddSharedToPath -and -not ( ($env:PATH -split ';') -contains $env:COTEMP_SHARED )) {
  $env:PATH = "$($env:COTEMP_SHARED);$($env:PATH)"
}
if ($AddBinToPath -and -not ( ($env:PATH -split ';') -contains $env:COTEMP_BIN )) {
  $env:PATH = "$($env:COTEMP_BIN);$($env:PATH)"
}

function Install-CoTempShims {
  param([string]$Pattern = '*.ps1')
  Get-ChildItem -Path $env:COTEMP_SHARED -Filter $Pattern | ForEach-Object {
    $name = $_.Name
    $shim = Join-Path $env:COTEMP_BIN $name
@"
# shim -> $name
param([Parameter(ValueFromRemainingArguments=`$true)][string[]]`$ArgsFromCaller)
& (Join-Path `"$env:COTEMP_SHARED`" `"$name`") @ArgsFromCaller
"@ | Set-Content -Encoding utf8 $shim
  }
}

Write-Host "CoTemp session ready:"
Write-Host "  SID   : $env:COTEMP_SID"
Write-Host "  BIN   : $env:COTEMP_BIN"
Write-Host "  LOG   : $env:COTEMP_LOG"
Write-Host "  SHARE : $env:COTEMP_SHARED"
