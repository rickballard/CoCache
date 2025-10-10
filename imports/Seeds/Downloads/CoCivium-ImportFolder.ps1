param(
  [string]$DestRepo = "$HOME\Documents\GitHub\CoCivium",
  [string]$SourceRepo = "$HOME\Documents\GitHub\Civium",
  [string]$RelFolder = "fragmentory\civium\src"
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
if(!(Test-Path $DestRepo)){ throw "DestRepo not found: $DestRepo" }
if(!(Test-Path $SourceRepo)){ Write-Host "SourceRepo missing ($SourceRepo). Skipping import."; exit 0 }
$src = Join-Path $SourceRepo $RelFolder
if(!(Test-Path $src)){ Write-Host "Source folder not found: $src"; exit 0 }

Set-Location $DestRepo
git fetch origin | Out-Null
$ts = Get-Date -Format 'yyyyMMdd_HHmmss'
$br = "import/civium_src_$ts"
git switch -c $br origin/main | Out-Null

$dest = Join-Path (Get-Location) $RelFolder
New-Item -ItemType Directory -Force -Path $dest | Out-Null
Copy-Item -Recurse -Force -LiteralPath $src -Destination (Split-Path $dest)  # preserves folder
git add -- $RelFolder

if(git diff --cached --quiet){ Write-Host "Nothing to import."; exit 0 }
git commit -m "import: Civium $RelFolder"
git push -u origin HEAD
if(Get-Command gh -ErrorAction SilentlyContinue){
  gh pr create -B main -t "Import: Civium $RelFolder" -b "First pass import; follow-up link cleanups via admin/index."
}
