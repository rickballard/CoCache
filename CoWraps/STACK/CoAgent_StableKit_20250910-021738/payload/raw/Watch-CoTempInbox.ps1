param(
  [Parameter(Mandatory)][string]$Inbox,
  [Parameter(Mandatory)][string]$Processed,
  [Parameter(Mandatory)][string]$RunDO,
  [string]$Tag
)

Write-Host "CoInboxWatcher starting... Inbox=$Inbox  Tag='$Tag'"
while ($true) {
  $items = Get-ChildItem -LiteralPath $Inbox -Filter *.ps1 -File -ErrorAction SilentlyContinue
  if ($Tag) { $items = $items | Where-Object { $_.Name -match [regex]::Escape($Tag) } }

  foreach ($it in $items | Sort-Object LastWriteTime) {
    try { & $RunDO -Path $it.FullName } catch { Write-Warning $_ }
    try {
      New-Item -ItemType Directory -Force -Path $Processed | Out-Null
      Move-Item -LiteralPath $it.FullName -Destination (Join-Path $Processed $it.Name) -Force
    } catch { Write-Warning $_ }
  }
  Start-Sleep -Milliseconds 750
}
