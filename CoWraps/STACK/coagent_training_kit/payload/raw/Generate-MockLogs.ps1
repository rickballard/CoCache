param([int]$Count = 20)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = (Get-Location).Path
$logDir = Join-Path $root ".coagent\logs"
New-Item -ItemType Directory -Force $logDir | Out-Null

$rand = New-Object System.Random
$routes = @("normal","guardrails_redirect","tool_error","tool_success")

$file = Join-Path $logDir ("bpoe-" + (Get-Date -Format "yyyyMMdd-HHmmss") + ".jsonl")
$w = [System.IO.StreamWriter]::new($file, $false, [System.Text.Encoding]::UTF8)
try {
  for($i=0; $i -lt $Count; $i++){
    $lat = $rand.Next(120, 2800)
    $sat = $rand.Next(1,6)
    $route = $routes[$rand.Next(0,$routes.Count)]
    $obj = @{
      ts=(Get-Date).ToString("o"); session_id=[guid]::NewGuid().ToString();
      user_id="local"; event="exchange"; latency_ms=$lat; satisfaction=$sat;
      route=$route; tokens_in=$rand.Next(50,800); tokens_out=$rand.Next(20,600)
    } | ConvertTo-Json -Compress
    $w.WriteLine($obj)
  }
} finally { $w.Close() }

Write-Host "🧪 Wrote $Count mock events → $file"
