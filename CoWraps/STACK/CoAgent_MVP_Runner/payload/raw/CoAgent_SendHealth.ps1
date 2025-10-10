param(
  [string]$Owner = "YOUR-ORG-OR-USER",
  [string]$Repo  = "YOUR-REPO"
)
$ErrorActionPreference = "SilentlyContinue"
$CT = Join-Path $env:USERPROFILE "Downloads\CoTemp"

$os  = (Get-CimInstance Win32_OperatingSystem | Select-Object -First 1 Caption, Version, BuildNumber)
$ps7 = $PSVersionTable.PSVersion.ToString()
$useTerminal = (Get-ItemProperty HKCU:\Console -Name UseTerminal -EA SilentlyContinue).UseTerminal
$jobsEnabled = (Get-ScheduledTask | Where-Object {
  $_.TaskName -match 'CoAgent|CoCivium|CoCache|CoBreadcrumb|Lehane' -and $_.State -in 'Ready','Running'
}).Count
$bpoe = Get-ChildItem $CT -Filter 'BPOE_Status_*.txt' | Sort LastWriteTime -desc | Select -First 1 |
        ForEach-Object { Get-Content $_ -Raw }

$payload = [ordered]@{
  schema     = 'coagent.health.v1'
  ts         = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')
  platform   = @{ os=$os.Caption; version=$os.Version; build=$os.BuildNumber }
  ps7        = $ps7
  terminal   = @{ UseTerminal = $useTerminal }
  jobs       = @{ enabled_now = $jobsEnabled }
  bpoe_line  = $bpoe
}

$fp = Join-Path $CT ("CoAgent_Health_{0:yyyyMMdd-HHmmss}.json" -f (Get-Date))
$payload | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 $fp

$title = [uri]::EscapeDataString("Health summary (manual)")
$body  = [uri]::EscapeDataString("```json`n$([IO.File]::ReadAllText($fp))`n```")
$uri   = "https://github.com/$Owner/$Repo/issues/new?title=$title&body=$body"
Start-Process $uri | Out-Null

Write-Host "Wrote $fp and opened your browser so you can review/send (or just close)." -ForegroundColor Yellow
