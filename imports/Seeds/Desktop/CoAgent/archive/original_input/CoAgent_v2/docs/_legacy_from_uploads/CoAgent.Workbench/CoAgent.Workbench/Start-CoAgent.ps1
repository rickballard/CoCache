param(
  [string]$Tag = '',
  [switch]$NoWatchers
)

# Determine kit location
$KitRoot   = Split-Path -Parent $PSCommandPath
$KitShared = Join-Path $KitRoot '_shared'
$KitScripts= Join-Path $KitRoot 'scripts'

# CoTemp root
$Root      = Join-Path $HOME 'Downloads/CoTemp'
$Shared    = Join-Path $Root '_shared'
$Scripts   = Join-Path $Root 'scripts'
$Inbox     = Join-Path $Root 'inbox'
$Logs      = Join-Path $Root 'logs'
$Sessions  = Join-Path $Root 'sessions'

New-Item -ItemType Directory -Force -Path $Shared,$Scripts,$Inbox,$Logs,$Sessions | Out-Null

# Copy kit files into CoTemp (idempotent updates)
Copy-Item -Recurse -Force -Path (Join-Path $KitShared '*')  -Destination $Shared  -ErrorAction SilentlyContinue
Copy-Item -Recurse -Force -Path (Join-Path $KitScripts '*') -Destination $Scripts -ErrorAction SilentlyContinue

# Prepare session env
$tagForId = ($Tag -ne '') ? $Tag : 'work'
$sid = (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + $tagForId + '-' + $PID

$env:COTEMP_ROOT    = $Root
$env:COTEMP_SHARED  = $Shared
$env:COTEMP_SID     = $sid
$env:COTEMP_TAG     = $Tag
$env:COTEMP_SESSION = Join-Path $Sessions $sid
$env:COTEMP_BIN     = Join-Path $env:COTEMP_SESSION 'bin'
$env:COTEMP_LOG     = Join-Path $env:COTEMP_SESSION 'logs'
$env:COTEMP_SCRATCH = Join-Path $env:COTEMP_SESSION 'scratch'

New-Item -ItemType Directory -Force -Path $env:COTEMP_BIN,$env:COTEMP_LOG,$env:COTEMP_SCRATCH | Out-Null

# Keep .NET CurrentDirectory aligned
try { $ExecutionContext.InvokeCommand.LocationChangedAction = { [Environment]::CurrentDirectory = (Get-Location).ProviderPath } } catch {}
[Environment]::CurrentDirectory = (Get-Location).ProviderPath

# PATH (process-scoped)
if ($env:PATH -notlike "*$($env:COTEMP_SHARED)*") { $env:PATH = "$($env:COTEMP_SHARED);$($env:PATH)" }
if ($env:PATH -notlike "*$($env:COTEMP_BIN)*")     { $env:PATH = "$($env:COTEMP_BIN);$($env:PATH)" }

# Load helpers
. (Join-Path $env:COTEMP_SHARED 'ctts-utils.ps1')

# Status
Write-Host "CoTemp session ready:"
Write-Host "  SID   : $env:COTEMP_SID"
Write-Host "  TAG   : $env:COTEMP_TAG"
Write-Host "  ROOT  : $env:COTEMP_ROOT"
Write-Host "  SHARE : $env:COTEMP_SHARED"
Write-Host "  BIN   : $env:COTEMP_BIN"
Write-Host "  LOG   : $env:COTEMP_LOG"
Write-Host ""

# Start watcher unless suppressed
if (-not $NoWatchers) {
  & (Join-Path $Scripts 'Start-CoWatchers.ps1') -Tag $Tag
}

# Quick status
& (Join-Path $Scripts 'Status-QuickCheck.ps1')
