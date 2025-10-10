
# DO — Install CoAgency InSights bundle into CoCivium repo
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repo = Join-Path $env:USERPROFILE 'Documents\GitHub\CoCivium'
$dst  = Join-Path $repo 'InSights\CoAgency'
$termsDst = Join-Path $dst 'terms\CoAgency'

$src  = "$PSScriptRoot"
if (!(Test-Path $repo)) { throw "Repo not found at $repo" }

New-Item -ItemType Directory -Path $dst -Force | Out-Null
New-Item -ItemType Directory -Path $termsDst -Force | Out-Null

Copy-Item "$src\CoAgency-Theory.md" $dst -Force
Copy-Item "$src\CoAgency-Implementation.md" $dst -Force
Copy-Item "$src\CoAgency-Visual-Core.png" $dst -Force
Copy-Item "$src\CoAgency-Visual-Core.svg" $dst -Force
Copy-Item "$src\CoAgency-Visual-Orbits.png" $dst -Force
Copy-Item "$src\CoAgency-Visual-Orbits.svg" $dst -Force
Copy-Item "$src\terms\CoAgency\*.md" $termsDst -Force

Push-Location $repo
git add .
git commit -m "InSights: Seed CoAgency (theory, implementation, visuals, GIBindex terms)"
Pop-Location

Write-Host "CoAgency bundle installed. Review and push when ready."
