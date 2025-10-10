param([Parameter(Mandatory)][string]$ToSessionId,
      [Parameter(Mandatory)][string]$Text)

$root = Join-Path $HOME 'Downloads\CoTemp'
$inbox = Join-Path $root ("sessions\{0}\inbox" -f $ToSessionId)
New-Item -ItemType Directory -Force -Path $inbox | Out-Null
$from = if ($env:COSESSION_ID) { $env:COSESSION_ID } else { 'unknown' }
$name = "NOTE_{0}_{1}.md" -f (Get-Date -Format 'yyyyMMdd-HHmmss'), $from
$dest = Join-Path $inbox $name
Set-Content -LiteralPath $dest -Encoding UTF8 -Value $Text
Write-Host ("Note sent -> {0}" -f $dest)
$dest
