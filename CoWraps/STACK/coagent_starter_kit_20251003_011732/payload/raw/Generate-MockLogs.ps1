
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = (Resolve-Path (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "..")).Path
$logDir = Join-Path $root ".coagent\logs"
New-Item -ItemType Directory -Force $logDir | Out-Null

$rows = @(
  @{ ts=(Get-Date).AddMinutes(-10).ToString("s"); user="elias"; intent="training.start"; session_id="sess-1"; note="launched training" }
  @{ ts=(Get-Date).AddMinutes( -9).ToString("s"); user="elias"; intent="training.step";  session_id="sess-1"; step=1 }
  @{ ts=(Get-Date).AddMinutes( -8).ToString("s"); user="elias"; intent="training.step";  session_id="sess-1"; step=2 }
  @{ ts=(Get-Date).AddMinutes( -7).ToString("s"); user="alex";  intent="ui.open";        session_id="sess-2"; page="status" }
  @{ ts=(Get-Date).AddMinutes( -6).ToString("s"); user="elias"; intent="guardrail.hit";  session_id="sess-1"; code="soft" }
  @{ ts=(Get-Date).AddMinutes( -5).ToString("s"); user="alex";  intent="feedback.good";  session_id="sess-2"; note="clear" }
)
$path = Join-Path $logDir ("events_{0}.jsonl" -f (Get-Date -Format "yyyyMMdd_HHmmss"))
$rows | ForEach-Object { ($_ | ConvertTo-Json -Compress) } | Set-Content -Encoding UTF8 $path
Write-Host "wrote $path"
