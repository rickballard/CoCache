# BPOE DO Block for PS7: Quick Reflex Pattern Registration to CoCache
$ReflexFolder = "$HOME\Documents\GitHub\CoCache\docs\Reflex"
New-Item -ItemType Directory -Force -Path $ReflexFolder | Out-Null
Copy-Item -Path "$PSScriptRoot\*.md" -Destination $ReflexFolder -Force
Write-Host "`n✅ Reflex Pattern Advice registered in CoCache/docs/Reflex.`n"
