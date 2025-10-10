Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
if (-not $env:COSESSION_ID) { $env:COSESSION_ID = "co-$PID-$(Get-Date -Format 'yyyyMMdd-HHmmss')" }
$script:CoRoot      = Join-Path $HOME 'Downloads\CoTemp'
$script:SessionRoot = Join-Path $script:CoRoot ("sessions\{0}" -f $env:COSESSION_ID)
$script:Inbox       = Join-Path $script:SessionRoot 'inbox'
$script:Outbox      = Join-Path $script:SessionRoot 'outbox'
$script:Logs        = Join-Path $script:SessionRoot 'logs'
$script:Scripts     = Join-Path $script:SessionRoot 'scripts'
$null = New-Item -ItemType Directory -Force -Path $script:CoRoot,$script:SessionRoot,$script:Inbox,$script:Outbox,$script:Logs,$script:Scripts | Out-Null
function CoTemp { param([string]$Rel) if ($Rel) { Join-Path $script:CoRoot $Rel } else { $script:CoRoot } }
function CoSession-Path { param([string]$Rel) if ($Rel) { Join-Path $script:SessionRoot $Rel } else { $script:SessionRoot } }
try { $dir = Join-Path $HOME "Downloads\CoTemp\common"; if (Test-Path $dir) { Get-ChildItem -Path $dir -Filter "*.ps1" -ErrorAction SilentlyContinue | ForEach-Object { . $_.FullName } } } catch {}
Write-Host ("CoTemp session ready: {0}" -f $env:COSESSION_ID) -ForegroundColor Cyan
