$ErrorActionPreference='Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

# TODO: replace with real CoSuite pulls
$rows = @(
  @{ id='us-democrats';   label='US Democrats';   group='party';  scores=@{ commons=0.58; commerce=0.50; club=0.46; crown=0.41 }; sources=@(@{title='Platform';url='https://example.org/dem';  date=(Get-Date -Format 'yyyy-MM-dd')}) },
  @{ id='us-republicans'; label='US Republicans'; group='party';  scores=@{ commons=0.40; commerce=0.59; club=0.52; crown=0.62 }; sources=@(@{title='Platform';url='https://example.org/rep';  date=(Get-Date -Format 'yyyy-MM-dd')}) }
)

$outObj = @{
  version = 2
  updated = (Get-Date -Format 'yyyy-MM-dd')
  weights = @{ commons=1; commerce=1; club=1; crown=1 }
  entities = $rows
}
$outJson = $outObj | ConvertTo-Json -Depth 8
$outFile = Join-Path $root 'plane-app\data\entities.v2.json'
New-Item -ItemType Directory -Force (Split-Path $outFile) | Out-Null
$outJson | Set-Content -Encoding utf8 $outFile

# CoSync receipt (Event/DataJson)
$emit = Join-Path $root 'scripts\Emit-CoSyncReceipt.ps1'
if (Test-Path $emit) {
  & $emit -Event 'plane-app:data-built' -DataJson (@{ version=2; count=$rows.Count } | ConvertTo-Json -Compress)
}

git add $outFile status
git commit -m "Plane data v2: $($rows.Count) entities" | Out-Null
git push | Out-Null
git cosync | Out-Null
"✅ Built and published entities.v2.json"
