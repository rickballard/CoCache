$zip = "$HOME\Downloads\HH\Advice_SeedCrystal_20251024_153510.zip"
$dest = "$HOME\Documents\GitHub\CoCache\docs\staging\Advice_SeedCrystal_20251024_153510"
Expand-Archive $zip -DestinationPath $dest -Force
Write-Host "Deployed to $dest"