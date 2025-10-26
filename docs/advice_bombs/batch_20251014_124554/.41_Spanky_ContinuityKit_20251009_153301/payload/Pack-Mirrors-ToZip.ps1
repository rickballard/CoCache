# Pack-Mirrors-ToZip.ps1
# Zips each bare mirror folder for manual copy to Synology.
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$MirrorsRoot = Join-Path $HOME "Documents\Backups\RepoMirrors"
$OutRoot     = Join-Path $HOME "Documents\Backups\TransferZips"
New-Item -ItemType Directory -Force -Path $OutRoot | Out-Null
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
Get-ChildItem -Path $MirrorsRoot -Directory -Filter "*.git" | ForEach-Object {
  $name = $_.Name -replace '\.git$',''
  $zip  = Join-Path $OutRoot "$($name)-$stamp.zip"
  Write-Host "Zipping $name -> $zip"
  Compress-Archive -Path $_.FullName -DestinationPath $zip -Force
}
Write-Host "Done. Copy zips from $OutRoot to your Synology share."

