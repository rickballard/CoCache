param([string]$Name='', [string]$Tag='work', [switch]$LF)
$root  = Join-Path $HOME 'Downloads/CoTemp'
$inbox = Join-Path $root 'inbox'
New-Item -ItemType Directory -Force -Path $inbox | Out-Null
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$slug  = ($Name ? $Name : 'do'); $slug = ($slug -replace '[^\w\-]+','-').Trim('-')
$fname = "{0}-{1}-{2}.ps1" -f $stamp,$Tag,$slug
$path  = Join-Path $inbox $fname

. (Join-Path $root '_shared\ctts-utils.ps1')
$text  = ctts -FromClipboard
if ($LF) { $text = $text -replace "`r?`n","`n" }
Set-Content -LiteralPath $path -Value $text -Encoding utf8
Write-Host "Dropped DO to inbox: $path"
$path
