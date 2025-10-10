param(
  [string]$Watch = (Join-Path $env:USERPROFILE "Downloads"),
  [switch]$Once
)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$CT       = Join-Path $env:USERPROFILE "Downloads\CoTemp"
$OutRoot  = Join-Path $CT "CoPayloads"
$PongDir  = Join-Path $CT "CoPong"
New-Item -ItemType Directory -Force -Path $OutRoot,$PongDir | Out-Null

Write-Host "CoPayloadRunner watching: $Watch" -ForegroundColor Cyan
$filter      = "*.zip"
$script:seen = [System.Collections.Concurrent.ConcurrentDictionary[string,byte]]::new()

function Get-SourceHint {
  param([string]$ZipPath, [string]$Work)
  $hint = [ordered]@{}
  # 1) _copayload.meta.json at extracted root
  $metaPath = Join-Path $Work "_copayload.meta.json"
  if (Test-Path $metaPath) {
    try {
      $meta = Get-Content $metaPath -Raw | ConvertFrom-Json
      if ($meta.session_hint) { $hint.session_hint = $meta.session_hint }
      if ($meta.reply_url)    { $hint.reply_url    = $meta.reply_url }
      if ($meta.notes)        { $hint.notes        = $meta.notes }
      $hint.meta_present = $true
    } catch {}
  }
  # 2) filename tag: __FROM_...__
  $m = [regex]::Match([IO.Path]::GetFileName($ZipPath), "__FROM_([A-Za-z0-9\.\-_]+)__")
  if ($m.Success) { $hint.from_tag = $m.Groups[1].Value }
  if ($hint.Keys.Count -eq 0) { return $null }
  return $hint
}

function Invoke-Payload {
  param([Parameter(Mandatory)][string]$zipPath)
  try {
    $name  = [IO.Path]::GetFileNameWithoutExtension($zipPath)
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $work  = Join-Path $OutRoot ("{0}_{1}" -f $name,$stamp)
    New-Item -ItemType Directory -Force -Path $work | Out-Null

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $work, $true)

    $run = Join-Path $work 'run.ps1'
    if (!(Test-Path $run)) { Write-Warning "No run.ps1 in $zipPath (skipping)."; return }

    $log = Join-Path $work 'payload.log.txt'
    Set-Content -Encoding UTF8 -Path $log -Value @("=== PAYLOAD: $zipPath","=== START:  $(Get-Date -Format o)")

    $pwsh = (Get-Command pwsh -ErrorAction SilentlyContinue | Select-Object -Expand Source -First 1)
    if (-not $pwsh) { $pwsh = "$env:ProgramFiles\PowerShell\7\pwsh.exe" }

    $psi = [System.Diagnostics.ProcessStartInfo]::new()
    $psi.FileName               = $pwsh
    $psi.Arguments              = "-NoLogo -NoProfile -ExecutionPolicy Bypass -File `"$run`""
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError  = $true
    $psi.UseShellExecute        = $false

    $p = [System.Diagnostics.Process]::Start($psi)
    $stdout = $p.StandardOutput.ReadToEnd()
    $stderr = $p.StandardError.ReadToEnd()
    $p.WaitForExit()

    Add-Content $log $stdout
    if ($stderr) { Add-Content $log "`n=== STDERR ===`n$stderr" }
    Add-Content $log ("=== EXIT:   {0}" -f $p.ExitCode)

    $source = Get-SourceHint -ZipPath $zipPath -Work $work
    $pong = Join-Path $PongDir ("CoPong_{0}_{1}.md" -f $name,$stamp)
    $tail = Get-Content $log -Tail 60
    $header = @("# CoPong — Payload result",
      "zip:   $zipPath",
      "time:  $(Get-Date -Format o)",
      "exit:  $($p.ExitCode)")
    if ($source) {
      $header += "source:"
      foreach($k in $source.Keys){ $header += "  {0}: {1}" -f $k,$source[$k] }
    }
    $pongLines = $header + @("", "## Log tail") + $tail
    Set-Content -Encoding UTF8 -Path $pong -Value $pongLines
# [MVP3] removed notepad popup
    Write-Host "CoPong created -> $pong" -ForegroundColor Yellow
  } catch {
    Write-Warning "Payload error: $($_.Exception.Message)"
  }
}

# Process existing zips once
Get-ChildItem $Watch -Filter $filter | Sort LastWriteTime |
  Where-Object { $script:seen.TryAdd($_.FullName,0) } |
  ForEach-Object { Invoke-Payload $_.FullName }

if ($Once) { return }

$fsw = [IO.FileSystemWatcher]::new($Watch, $filter)
$fsw.IncludeSubdirectories = $false
$fsw.EnableRaisingEvents   = $true
Register-ObjectEvent -InputObject $fsw -EventName Created -SourceIdentifier "ZipWatch" -Action {
  Start-Sleep -Milliseconds 300
  $path = $Event.SourceEventArgs.FullPath
  if ($script:seen.TryAdd($path,0)) { Invoke-Payload $path }
} | Out-Null

Write-Host "Press Ctrl+C to stop…" -ForegroundColor DarkGray
while ($true) { Start-Sleep 1 }

