# CoAgent.CoPingPong.ps1 — minimal, safe CoPingPong runner
# Watches a queue folder for incoming .ps1 or .md/.txt files.
# - For .ps1: enqueue the script for user-confirmed execution.
# - For .md/.txt: extracts [PASTE IN POWERSHELL] fenced code blocks and enqueues them as ephemeral scripts.
# Safety defaults: no auto-exec; user presses Enter to run each item. Logs outputs.
param(
  [string]$Queue = "$HOME\Downloads\CoTemps\PingQueue",
  [string]$Work  = "$HOME\Downloads\CoTemps\Work",
  [string]$Logs  = "$HOME\Downloads\CoTemps\Logs",
  [int]$StableMs = 500,      # time with no size change considered "stable"
  [switch]$VerboseLog
)

$ErrorActionPreference = 'Stop'
$PSStyle.OutputRendering = 'Ansi'

# Ensure folders
$null = New-Item -ItemType Directory -Force -Path $Queue, $Work, $Logs

function Write-Info($msg) { Write-Host "[CoAgent] $msg" }
function Write-Warn($msg) { Write-Host "[CoAgent] $msg" -ForegroundColor Yellow }
function Write-Err ($msg) { Write-Host "[CoAgent] $msg" -ForegroundColor Red }

function Wait-FileStable([string]$Path, [int]$StableMs=500, [int]$TimeoutMs=60000) {
  $sw = [System.Diagnostics.Stopwatch]::StartNew()
  $lastSize = -1
  $stableFor = 0
  while ($sw.ElapsedMilliseconds -lt $TimeoutMs) {
    if (-not (Test-Path $Path)) { Start-Sleep -Milliseconds 50; continue }
    try {
      $fi = Get-Item $Path -ErrorAction Stop
      $size = $fi.Length
      if ($size -eq $lastSize) {
        $stableFor += 100
        if ($stableFor -ge $StableMs) { return $true }
      } else {
        $stableFor = 0
        $lastSize = $size
      }
    } catch { }
    Start-Sleep -Milliseconds 100
  }
  return $false
}

function New-EphemeralScript([string]$Content, [string]$Prefix="QueueItem") {
  $name = "{0}_{1:yyyyMMdd_HHmmss_fff}.ps1" -f $Prefix, (Get-Date)
  $path = Join-Path $Work $name
  Set-Content -Path $path -Value $Content -NoNewline -Encoding UTF8
  return $path
}

function Parse-CoBlocks([string]$Text) {
  # Extract PowerShell blocks that are labeled with a preceding line "[PASTE IN POWERSHELL]"
  # Pattern: a line with [PASTE IN POWERSHELL] followed by a fenced ``` block (any language)
  $blocks = @()
  $lines = $Text -split "\r?\n"
  for ($i=0; $i -lt $lines.Count; $i++) {
    if ($lines[$i].Trim() -match '^\[PASTE IN POWERSHELL\]\s*$') {
      # scan forward to find opening ```
      $j = $i + 1
      while ($j -lt $lines.Count -and $lines[$j].Trim() -notmatch '^```') { $j++ }
      if ($j -ge $lines.Count) { break }
      $j++ # move to first content line after ```
      $content = New-Object System.Collections.Generic.List[string]
      while ($j -lt $lines.Count -and $lines[$j].Trim() -notmatch '^```') {
        $content.Add($lines[$j])
        $j++
      }
      if ($content.Count -gt 0) {
        $blocks += ($content -join "`r`n")
      }
      $i = $j
    }
  }
  return ,$blocks
}

function Invoke-Queued([string]$ItemPath) {
  $base = Split-Path $ItemPath -Leaf
  Write-Info "Queued: $base"

  $ext = [IO.Path]::GetExtension($ItemPath).ToLowerInvariant()
  $toRun = @()

  if ($ext -eq ".ps1") {
    $toRun += $ItemPath
  } elseif ($ext -in @(".md",".txt")) {
    $text = Get-Content -Raw -Path $ItemPath
    $blocks = Parse-CoBlocks -Text $text
    if ($blocks.Count -eq 0) {
      Write-Warn "No [PASTE IN POWERSHELL] blocks found in $base"
    } else {
      $k = 0
      foreach ($b in $blocks) {
        $k++
        $ep = New-EphemeralScript -Content $b -Prefix ($base -replace '\W','_')+"_b$k"
        $toRun += $ep
      }
    }
  } else {
    Write-Warn "Unsupported file type: $base"
    return
  }

  foreach ($script in $toRun) {
    $short = Split-Path $script -Leaf
    Write-Host ""
    Write-Host ">>> READY: $short" -ForegroundColor Cyan
    Write-Host "    Press ENTER to run, or 's' to skip, or 'q' to stop." -ForegroundColor DarkGray
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    if ($key.Character -eq 'q') { throw "User aborted." }
    if ($key.Character -eq 's') { Write-Warn "Skipped $short"; continue }

    $logFile = Join-Path $Logs ("{0}_{1:yyyyMMdd_HHmmss}.log" -f ($short -replace '\.ps1$',''), (Get-Date))
    Write-Host ">>> RUNNING: $short" -ForegroundColor Green
    try {
      $start = Get-Date
      $out = & $script 2>&1 | Out-String
      $end = Get-Date
      $report = @"
=== Script: $short
=== Started: $start
=== Ended  : $end

$output:
$out
"@
      Set-Content -Path $logFile -Value $report -Encoding UTF8
      Write-Host "<<< DONE: $short  (log: $logFile)" -ForegroundColor Green
    } catch {
      $err = $_ | Out-String
      Set-Content -Path $logFile -Value ("ERROR:" + [Environment]::NewLine + $err) -Encoding UTF8
      Write-Err "Failed: $short  (see $logFile)"
    }
  }
}

Write-Info "Watching queue: $Queue"
$watcher = New-Object IO.FileSystemWatcher $Queue, "*.*"
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

$handler = Register-ObjectEvent $watcher Created -Action {
  param($sender,$eventArgs)
  $p = $eventArgs.FullPath
  if (-not (Wait-FileStable -Path $p -StableMs $using:StableMs)) {
    Write-Warn "File not stable in time: $p"; return
  }
  try {
    Invoke-Queued -ItemPath $p
  } catch {
    Write-Err ($_ | Out-String)
  }
}

Write-Info "Drop .ps1 or .md/.txt into: $Queue"
Write-Info "Press Ctrl+C to stop."
while ($true) { Start-Sleep -Seconds 1 }
