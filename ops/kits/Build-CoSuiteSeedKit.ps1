param([string]$OutDir = "$HOME\Downloads")
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest

$root = (Resolve-Path "$HOME\Documents\GitHub\CoCache").Path
$ts = Get-Date -Format 'yyyy-MM-dd_HHmmss'
$kit = Join-Path $OutDir "CoSuite-SeedKit_$ts"
New-Item -ItemType Directory -Force -Path $kit | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $kit "scripts") | Out-Null

# Harvest scripts from CoCache that we’ve been using
$want = @(
  "HANDOVER\CoWrap-20251010-132935\ops\snippets\seed-finish.ps1", # finisher (remote)
  "Invoke-CoCacheHandover.ps1",
  "ops\CoSuite\Invoke-CoSuiteSeed.ps1",
  "ops\humanize\Build-FrontDoor.ps1",
  "ops\humanize\Write-HumansIndex.ps1"
) | ForEach-Object { Join-Path $root $_ }

foreach($p in $want){
  if(Test-Path $p){ Copy-Item $p (Join-Path $kit "scripts") -Force }
}

# Add a README for the kit
@"
CoSuite Seed Kit ($ts)

1) Bootstrap handovers if missing (per repo).
2) Run the finisher (PR → merge/auto → sync main).
3) Orchestrate across repos with Invoke-CoSuiteSeed.ps1.
4) Humanize each repo's front door (README/HUMANS).

All scripts are idempotent and print a green DONE sentinel.
"@ | Set-Content (Join-Path $kit "README.txt") -Encoding UTF8

# Zip it
$zip = Join-Path $OutDir "CoSuite-SeedKit_$ts.zip"
if(Test-Path $zip){ Remove-Item $zip -Force }
Compress-Archive -Path (Join-Path $kit "*") -DestinationPath $zip
Write-Host "==> DONE: Kit at $zip" -ForegroundColor Green

