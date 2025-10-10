# DO — Inject CoRef hook into Hitchhiker Plan (Godspawn)
$hh = "$env:USERPROFILE\Documents\GitHub\Godspawn\HH"
$src = "$env:USERPROFILE\Downloads\CoRef_HH_AdviceBomb_Unzipped"
Copy-Item -Path "$src\HH_CoRefIndex.yaml" -Destination "$hh\HH_CoRefIndex.yaml" -Force
Write-Output "✅ CoRef index injected into HH."
