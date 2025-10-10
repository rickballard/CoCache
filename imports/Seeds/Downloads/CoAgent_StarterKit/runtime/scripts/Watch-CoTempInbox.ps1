param(
  [string]$Inbox,
  [string]$Processed,
  [string]$RunDO
)

Write-Host "CoInboxWatcher starting... (Inbox=$Inbox)"
while ($true) {
  Get-ChildItem $Inbox -Filter *.ps1 -File | Sort LastWriteTime |
    ForEach-Object {
      try { & $RunDO -Path $_.FullName } catch { Write-Warning $_ }
      try {
        $dest = Join-Path $Processed $_.Name
        Move-Item -LiteralPath $_.FullName -Destination $dest -Force
      } catch { Write-Warning $_ }
    }
  Start-Sleep -Seconds 2
}
