param(
  [string]$Watch = (Join-Path $env:USERPROFILE "Downloads"),
  [switch]$Once
)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$CT = Join-Path $env:USERPROFILE "Downloads\CoTemp"
$OutRoot = Join-Path $CT "CoPayloads"
$PongDir = Join-Path $CT "CoPong"
New-Item -ItemType Directory -Force -Path $OutRoot,$PongDir | Out-Null

Write-Host "CoPayloadRunner watching: $Watch" -ForegroundColor Cyan
$filter = "*.zip"
$seen = New-Object System.Collections.Concurrent.ConcurrentDictionary[string,byte]

function Invoke-Payload($zipPath) {
  try {
    $name = [IO.Path]::GetFileNameWithoutExtension($zipPath)
    $stamp = (Get-Date).ToString("yyyyMMdd-HHmmss")
    $work = Join-Path $OutRoot ("{0}_{1}" -f $name,$stamp)
    New-Item -ItemType Directory -Force -Path $work | Out-Null

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $work, $true)

    $run = Join-Path $work "run.ps1"
    if (-not (Test-Path $run)) {
      Write-Warning "No run.ps1 in $zipPath (skipping)."
      return
    }

    $log = Join-Path $work "payload.log.txt"
    "=== PAYLOAD: $zipPath" | Set-Content -Encoding UTF8 $log
    "=== START:  $(Get-Date -Format o)" | Add-Content $log

    # Execute with constrained settings
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $pwsh = (Get-Command pwsh -ErrorAction SilentlyContinue | Select-Object -First 1).Source
    if (-not $pwsh) { $pwsh = "powershell" }
    $psi.FileName = $pwsh
    $psi.Arguments = "-NoLogo -NoProfile -ExecutionPolicy Bypass -File `"$run`""
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError  = $true
    $psi.UseShellExecute        = $false
    $p = [System.Diagnostics.Process]::Start($psi)
    $stdout = $p.StandardOutput.ReadToEnd()
    $stderr = $p.StandardError.ReadToEnd()
    $p.WaitForExit()

    Add-Content $log $stdout
    if ($stderr) { Add-Content $log "`n=== STDERR ===`n$stderr" }

    "=== EXIT:   $($p.ExitCode)" | Add-Content $log

    # CoPong (manual share)
    $pong = Join-Path $PongDir ("CoPong_{0}_{1}.md" -f $name,$stamp)
@"
# CoPong — Payload result
zip:   $zipPath
time:  $(Get-Date -Format o)
exit:  $($p.ExitCode)

## Log tail
```
$([string]::Join("`n", (Get-Content $log -Tail 60)))
```
"@ | Set-Content -Encoding UTF8 $pong
# [MVP3] removed notepad popup
    Write-Host "CoPong created -> $pong" -ForegroundColor Yellow
  }
  catch {
    Write-Warning "Payload error: $($_.Exception.Message)"
  }
}

# process any new zips immediately (then optionally watch)
Get-ChildItem $Watch -Filter $filter | Sort LastWriteTime |
  Where-Object { $seen.TryAdd($_.FullName,0) } |
  ForEach-Object { Invoke-Payload $_.FullName }

if ($Once) { return }

$fsw = New-Object IO.FileSystemWatcher $Watch, $filter
$fsw.IncludeSubdirectories = $false
$fsw.EnableRaisingEvents = $true
Register-ObjectEvent $fsw Created -SourceIdentifier "ZipWatch" -Action {
  Start-Sleep -Milliseconds 300  # let the write finish
  $path = $Event.SourceEventArgs.FullPath
  if ($script:seen.TryAdd($path,0)) { Invoke-Payload $path }
} | Out-Null

Write-Host "Press Ctrl+C to stop…" -ForegroundColor DarkGray
while ($true) { Start-Sleep 1 }

