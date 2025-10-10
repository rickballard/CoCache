# Seed-BCGData.ps1
param([Parameter(Mandatory=$true)][string]$RickPublicPath)
Set-Location $RickPublicPath
New-Item -ItemType Directory -Force -Path .\infographics\matrices | Out-Null
@'
country,inst_resilience,crisis_exploitation,pop_or_gdp
Exampleland,0.35,0.78,50
'@ | Set-Content .\infographics\matrices\data.csv -Encoding UTF8
git add .\infographics\matrices\data.csv
git commit -m "infographics: seed BCG matrix data (example row)"
git push
