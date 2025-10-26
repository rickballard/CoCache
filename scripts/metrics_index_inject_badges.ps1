param(
  [string]$IndexPath = "$HOME\\Documents\\GitHub\\CoCache\\docs\\METRICS_INDEX.md",
  [string]$Root      = "$HOME\\Documents\\GitHub\\CoCache"
)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest

if(!(Test-Path $IndexPath)){ throw "Missing $IndexPath — generate it first." }
$badgesJson = pwsh -NoProfile -File (Join-Path $Root "scripts\\metrics_badges.ps1") -Root $Root
$badges = $badgesJson | ConvertFrom-Json

$lines = Get-Content $IndexPath
$new = @()
$inMetricsTable = $false

for($i=0;$i -lt $lines.Count;$i++){
  $line = $lines[$i]

  if($line -match '^\|\s*id\s*\|\s*cadence'){
    # header row -> insert Status first
    $inMetricsTable = $true
    $new += ($line -replace '^\|\s*id\s*\|', '| status | id |')
    # next line should be the separator
    if($i+1 -lt $lines.Count -and $lines[$i+1] -match '^\|\s*-+'){
      $new += ($lines[$i+1] -replace '^\|\s*-+\s*\|', '|---|---|')
      $i++ # skip the original separator we just handled
    }
    continue
  }

  if($inMetricsTable -and $line -match '^\|\s*`([^`]+)`\s*\|'){
    $id = $Matches[1]
    $badge = if($badges.PSObject.Properties.Name -contains $id){ $badges.$id } else { 'assets/brand/cocivium_status_gray.svg' }
    $newline = $line -replace '^\|', "| ![]($badge) |"
    $new += $newline
    continue
  }

  # end of table when a blank line encountered after table start
  if($inMetricsTable -and [string]::IsNullOrWhiteSpace($line)){
    $inMetricsTable = $false
    $new += $line
    continue
  }

  $new += $line
}

$new | Set-Content -Encoding UTF8 $IndexPath
Write-Host "✅ Injected status badges into METRICS_INDEX.md"

