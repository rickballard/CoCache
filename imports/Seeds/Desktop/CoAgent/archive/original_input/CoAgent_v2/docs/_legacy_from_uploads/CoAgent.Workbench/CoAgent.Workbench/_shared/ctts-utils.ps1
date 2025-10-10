# ctts-utils.ps1 — tiny helpers + safe fallbacks

function Convert-TranscriptToScript {
  [CmdletBinding()]
  param([string[]]$Text)
  if (-not $Text) { return "" }
  # Fallback: pass-through join. If a richer implementation exists in scope, it will shadow this.
  return ($Text -join "`n")
}

function ctts {
  [CmdletBinding()]
  param(
    [switch]$FromClipboard,
    [Parameter(ValueFromPipeline, Position=0)][string[]]$Text
  )
  begin { $buf = [System.Collections.Generic.List[string]]::new() }
  process {
    if ($FromClipboard) {
      $raw = Get-Clipboard -Raw
      if ($null -ne $raw) { $buf.AddRange(($raw -split "`r?`n")) }
    } elseif ($Text) {
      $buf.AddRange($Text)
    } elseif ($null -ne $_) {
      $buf.Add($_)
    }
  }
  end {
    $arr = $buf.ToArray()
    try {
      return Convert-TranscriptToScript -Text $arr
    } catch {
      return ($arr -join "`n")
    }
  }
}

function ctts-save {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory,Position=0)][string]$Path,
    [switch]$LF,
    [string]$Encoding = 'utf8'
  )
  $txt = ctts -FromClipboard
  if ($LF) { $txt = $txt -replace "`r?`n", "`n" }
  $full = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
  $dir  = Split-Path -Path $full -Parent
  if ($dir -and -not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  Set-Content -LiteralPath $full -Value $txt -Encoding $Encoding
  return $full
}

function Invoke-WithDots {
  param([Parameter(Mandatory)][scriptblock]$Script,[int]$EveryMs=300,[string]$Label="")
  $job = Start-Job $Script
  try {
    $sw=[Diagnostics.Stopwatch]::StartNew()
    if ($Label){Write-Host -NoNewline "$Label "}
    while($job.State -eq 'Running'){Write-Host -NoNewline '.'; Start-Sleep -Milliseconds $EveryMs}
    Write-Host " $($sw.Elapsed.ToString('mm\:ss'))"
    Receive-Job $job
  } finally { Remove-Job $job -Force -ErrorAction SilentlyContinue }
}
Set-Alias dots Invoke-WithDots
function clipfix { ctts -FromClipboard | Set-Clipboard }
Set-Alias cf clipfix
