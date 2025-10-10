param([string]$ToSessionId='',
      [string]$Name='do',
      [string]$Tag='work',
      [switch]$FromClipboard)

$root = Join-Path $HOME 'Downloads\CoTemp'
$inbox = if ($ToSessionId) { Join-Path $root ("sessions\{0}\inbox" -f $ToSessionId) } else { Join-Path $root 'inbox' }
New-Item -ItemType Directory -Force -Path $inbox | Out-Null

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$slug = ($Name -replace '[^\w\-]+','-').Trim('-'); if (-not $slug) { $slug = 'do' }
$fname = "{0}-{1}-{2}.ps1" -f $stamp,$Tag,$slug
$dest = Join-Path $inbox $fname

$text = if ($FromClipboard) { Get-Clipboard -Raw } else { 'Write-Host "Hello from DO"' }
Set-Content -LiteralPath $dest -Encoding UTF8 -Value $text
Write-Host ("Dropped DO: {0}" -f $dest)
$dest
