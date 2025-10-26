# DO — Integrate Session Summary Pack
param([string] $CoreRepo="$HOME\Documents\GitHub\CoCore",[string] $CacheRepo="$HOME\Documents\GitHub\CoCache",[switch] $WhatIf)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
$exRoot = Join-Path $CoreRepo 'BestPractices\Exemplars\Governance\_starter'
$cache = Join-Path $CacheRepo 'ExemplarCanon\runs'
$docs  = Join-Path $CoreRepo 'Docs\ExemplarCanon'
foreach($d in @($exRoot,$cache,$docs)){ if($WhatIf){Write-Host "[WhatIf] mkdir $d"} else {New-Item -ItemType Directory -Force -Path $d | Out-Null} }
Write-Host "Scaffold ready. Copy pack contents as needed." -ForegroundColor Green

