param(
  [string]$Name='',
  [string]$Tag='work',
  [switch]$Run,
  [switch]$Dots,
  [switch]$LF
)
$session = $env:COTEMP_SESSION
if (-not $session) { $session = Join-Path (Join-Path $HOME 'Downloads/CoTemp') 'sessions/manual' }
$scripts = Join-Path $session 'scripts'
New-Item -ItemType Directory -Force -Path $scripts | Out-Null

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$slug  = if ($Name) { $Name } else { 'do' }
$slug  = ($slug -replace '[^\w\-]+','-').Trim('-')
$fname = "{0}-{1}-{2}.ps1" -f $stamp,$Tag,$slug
$path  = Join-Path $scripts $fname

$text = ctts -FromClipboard
if ($LF) { $text = $text -replace "`r?`n","`n" }
Set-Content -LiteralPath $path -Value $text -Encoding utf8NoBOM
Write-Host "Saved DO: $path"

if ($Run) {
  $runner = Join-Path (Split-Path $PSCommandPath -Parent) 'Run-DO.ps1'
  if (Test-Path $runner) { & $runner -Path $path -Dots:$Dots } else { & $path }
}
$path
