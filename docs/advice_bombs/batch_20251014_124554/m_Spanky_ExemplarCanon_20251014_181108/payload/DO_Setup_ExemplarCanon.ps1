# DO — Setup Exemplar Canon scaffolding (v0.1)
param([string] $CoreRepo="$HOME\Documents\GitHub\CoCore",[string] $CacheRepo="$HOME\Documents\GitHub\CoCache",[switch] $WhatIf)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
$exRoot   = Join-Path $CoreRepo 'BestPractices\Exemplars\Governance\_starter'
$cacheRun = Join-Path $CacheRepo 'ExemplarCanon\runs'
foreach($d in @($exRoot,$cacheRun)){ if($WhatIf){ Write-Host "[WhatIf] mkdir $d"} else { New-Item -ItemType Directory -Force -Path $d | Out-Null } }
Copy-Item -Path "$PSScriptRoot\..\payload\EXEMPLAR_TEMPLATE.md" -Destination (Join-Path $exRoot 'EXEMPLAR_TEMPLATE.md') -Force
Copy-Item -Path "$PSScriptRoot\..\payload\exemplar.schema.json" -Destination (Join-Path $exRoot 'exemplar.schema.json') -Force

