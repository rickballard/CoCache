function Send-CoNote { [CmdletBinding()]param([Parameter(Mandatory)][string]$ToSessionId,[Parameter(Mandatory)][string]$Text)
  $root = Join-Path $HOME 'Downloads\CoTemp'
  $inbox = Join-Path (Join-Path $root ("sessions\{0}" -f $ToSessionId)) 'inbox'
  if (-not (Test-Path $inbox)) { New-Item -ItemType Directory -Force -Path $inbox | Out-Null }
  $from = if ($env:COSESSION_ID) { $env:COSESSION_ID } else { "unknown" }
  $name = "NOTE_{0}_{1}.md" -f (Get-Date -Format 'yyyyMMdd-HHmmss'), $from
  $path = Join-Path $inbox $name
  Set-Content -LiteralPath $path -Value $Text -Encoding UTF8
  Write-Host ("Note sent -> {0}" -f $path) -ForegroundColor Green
}
function Start-CoNoteReader { [CmdletBinding()]param([switch]$Loop,[int]$PollMs=800)
  if (-not $env:COSESSION_ID) { Write-Warning "No session id."; return }
  $root = Join-Path $HOME 'Downloads\CoTemp'; $sess = Join-Path $root ("sessions\{0}" -f $env:COSESSION_ID)
  $inbox = Join-Path $sess 'inbox'; $notes = Join-Path $sess 'notes'; $null = New-Item -ItemType Directory -Force -Path $inbox,$notes | Out-Null
  do {
    Get-ChildItem -LiteralPath $inbox -Filter 'NOTE_*.md' -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime |
      ForEach-Object { $t = Get-Content -Raw -LiteralPath $_.FullName; Write-Host ("NOTE {0}: {1}" -f $_.Name, $t) -ForegroundColor Yellow; Move-Item -LiteralPath $_.FullName -Destination (Join-Path $notes $_.Name) -Force }
    if (-not $Loop) { break }
    Start-Sleep -Milliseconds $PollMs
  } while ($true)
}
