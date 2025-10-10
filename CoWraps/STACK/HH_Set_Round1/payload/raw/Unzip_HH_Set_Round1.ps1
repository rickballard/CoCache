
Set-StrictMode -Version Latest
$zip = "$env:USERPROFILE\Downloads\HH_Set_Round1.zip"
$dest = "$env:USERPROFILE\Downloads\HH_Set_Round1"
Expand-Archive -Path $zip -DestinationPath $dest -Force
Get-ChildItem -Path $dest -Filter *.ps1 | ForEach-Object { pwsh -File $_.FullName }
Remove-Item $zip -Force
