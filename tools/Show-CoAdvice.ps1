param([string]$Root)
function V([string]$s){ Write-Host $s -ForegroundColor Magenta }

$AdviceIdx = Join-Path (Join-Path $Root 'docs\intent\advice\index') 'advice.index.json'
if (!(Test-Path $AdviceIdx)) { V 'Advice: (none indexed yet)'; exit 0 }

$adv  = Get-Content $AdviceIdx -Raw | ConvertFrom-Json
$AdvN = $adv.Count
V ("Advice families: {0}; latest:" -f $AdvN)

$adv | Sort-Object latestTs -Descending | Select-Object -First 5 | ForEach-Object {
  V ("  - {0} — {1}" -f $_.latestTs, $_.latestPath)
}

$overs = @()
$adv | ForEach-Object {
  if ($_.latestPath -and (Test-Path $_.latestPath)) {
    $kb = [math]::Round((Get-Item $_.latestPath).Length/1KB)
    if ($kb -gt 256) { $overs += ("{0} ({1} KB)" -f $_.family,$kb) }
  }
}
if ($overs.Count) { V ("  ⚠ Oversized: {0}" -f ($overs -join ', ')) }

