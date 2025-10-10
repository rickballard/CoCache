param(
  [Parameter(Mandatory)][string]$Inbox,
  [Parameter(Mandatory)][string]$Processed,
  [Parameter(Mandatory)][string]$RunDO,
  [string]$Tag  # optional: e.g. 'gmig'
)

# Derive Tag if not provided (from env)
if (-not $Tag) {
  if ($env:COTEMP_TAG) { $Tag = $env:COTEMP_TAG }
  elseif ($env:COTEMP_SID -and ($env:COTEMP_SID -match '-([A-Za-z0-9]+)-\d+$')) { $Tag = $matches[1] }
}

New-Item -ItemType Directory -Force -Path $Processed | Out-Null
Write-Host "CoInboxWatcher starting... Inbox=$Inbox  Tag='$Tag'  RunDO=$RunDO"

while ($true) {
  $items = Get-ChildItem -LiteralPath $Inbox -Filter *.ps1 -File -ErrorAction SilentlyContinue
  if ($Tag) {
    $items = $items | Where-Object { $_.Name -match [regex]::Escape($Tag) }
  }

  foreach ($it in $items | Sort-Object LastWriteTime) {
    try {
      $dest = Join-Path $Processed $it.Name
      if (Test-Path -LiteralPath $dest) {
        Remove-Item -LiteralPath $it.FullName -Force -ErrorAction SilentlyContinue
        continue
      }
      & $RunDO -Path $it.FullName
    } catch {
      Write-Warning ("Run failed for {0}: {1}" -f $it.Name, $_.Exception.Message)
    } finally {
      try {
        $dest = Join-Path $Processed $it.Name
        Move-Item -LiteralPath $it.FullName -Destination $dest -Force
      } catch {
        Write-Warning ("Move failed for {0}: {1}" -f $it.Name, $_.Exception.Message)
      }
    }
  }
  Start-Sleep -Milliseconds 750
}
