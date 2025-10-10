param([string]$Name='', [string]$Tag='work', [switch]$LF)

$root  = Join-Path $HOME 'Downloads\CoTemp'
$inbox = Join-Path $root 'inbox'
New-Item -ItemType Directory -Force -Path $inbox | Out-Null
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

$slug = $Name
if (-not $slug -or $slug -eq '') { $slug = 'do' }
$slug = ($slug -replace '[^\w\-]+','-').Trim('-')
$fname = ("{0}-{1}-{2}.ps1" -f $stamp,$Tag,$slug)
$dest  = Join-Path $inbox $fname

# Try to load shared utils; add safe fallback if ctts is missing
try { . (Join-Path (Split-Path $PSCommandPath -Parent) 'ctts-utils.ps1') } catch {}

if (-not (Get-Command Convert-TranscriptToScript -ErrorAction SilentlyContinue)) {
  function Global:Convert-TranscriptToScript { param([string[]]$Text) if (-not $Text) { return "" } ($Text -join "`n") }
}
if (-not (Get-Command ctts -ErrorAction SilentlyContinue)) {
  function ctts { param([switch]$FromClipboard) if ($FromClipboard) { return Convert-TranscriptToScript -Text ((Get-Clipboard -Raw) -split "`r?`n") } }
}

$text = ctts -FromClipboard
if ($LF) { $text = $text -replace "`r?`n","`n" }

# Write as UTF-8 (PS5.1 safe); if that fails, write via .NET without BOM
try { Set-Content -LiteralPath $dest -Value $text -Encoding UTF8 -Force }
catch { $enc = New-Object System.Text.UTF8Encoding($false); [IO.File]::WriteAllText($dest,$text,$enc) }

Write-Host "Dropped DO to inbox: $dest"
$dest
