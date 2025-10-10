# Quiet a noisy/crashy session without touching your repo
$ErrorActionPreference='SilentlyContinue'
try {
  Get-EventSubscriber -ErrorAction SilentlyContinue | Where-Object {
    $_.SourceIdentifier -in 'PowerShell.Exiting','OEStatusTimer','BPOE_Exiting'
  } | Unregister-Event -Force -ErrorAction SilentlyContinue
} catch {}
try { Get-Job -Name OEStatusTimer,BPOE_Exiting -ErrorAction SilentlyContinue | Remove-Job -Force -ErrorAction SilentlyContinue } catch {}

try { $global:BpoeAuditDone=$true } catch {}
try { $script:BpoeAuditDone=$true } catch {}
try { $global:__OEStatusNext=[DateTime]::MaxValue } catch {}

# Clear crash sentinel & record current PS version
try {
  $state = Join-Path $env:LOCALAPPDATA 'CoBPOE'
  [IO.Directory]::CreateDirectory($state) | Out-Null
  $sentinel = Join-Path $state 'session.sentinel'
  $verfile  = Join-Path $state 'psver.txt'
  Remove-Item -LiteralPath $sentinel -Force -ErrorAction SilentlyContinue
  [IO.File]::WriteAllText($verfile, $PSVersionTable.PSVersion.ToString(), [Text.UTF8Encoding]::new($true))
} catch {}
Write-Host "[CoSafe] Session quieted." -ForegroundColor Green