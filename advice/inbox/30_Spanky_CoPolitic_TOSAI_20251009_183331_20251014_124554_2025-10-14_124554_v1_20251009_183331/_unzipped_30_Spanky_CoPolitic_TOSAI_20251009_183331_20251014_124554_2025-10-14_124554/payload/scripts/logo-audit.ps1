# logo-audit.ps1 — Refresh logos audit from common locations
[CmdletBinding()]param()
$ErrorActionPreference = 'SilentlyContinue'
$dl   = Join-Path $HOME 'Downloads'
$one  = if ($env:OneDrive) { Join-Path $env:OneDrive 'Downloads' } else { $null }
$roots = @($dl, $one, (Join-Path $HOME 'Desktop'), (Join-Path $HOME 'Pictures')) | Where-Object { $_ -and (Test-Path $_) }
$slugs = 'openai','arc','chai','anthropic','redwoodresearch','github','sff','inseed','foresightinstitute','macarthurfoundation','skollfoundation','osf','govai','rand','nist','oecdai','carnegieendowment','maxbarry','bretvictor','chrislehane','gatesfoundation','emersoncollective','mitmedialab'
$wrapRoot = $PSScriptRoot | Split-Path -Parent | Split-Path -Parent
$logos  = Join-Path $wrapRoot 'logos'
$staged = Join-Path $logos 'staged'
New-Item -ItemType Directory -Force $staged | Out-Null
$cands = foreach($r in $roots){ Get-ChildItem -Path $r -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -match '^\.(png|jpe?g|svg)$' } }
$rows = @()
foreach ($s in $slugs) {
  $rx = switch($s){
    'arc' { 'arc|alignment\s*research' }
    'chai' { 'chai|human[-\s]*compatible' }
    'sff' { 'sff|survival\s*and\s*flourishing' }
    'foresightinstitute' { 'foresight(\s*institute)?' }
    'macarthurfoundation' { 'mac\s*arthur|macarthur' }
    'skollfoundation' { 'skoll' }
    'osf' { 'osf|open\s*society' }
    'govai' { 'govai|governance\s*of\s*ai' }
    'rand' { 'rand(\s*corp(oration)?)?' }
    'oecdai' { 'oecd(\s*ai)?' }
    'carnegieendowment' { 'carnegie\s*endowment' }
    'gatesfoundation' { 'gates\s*foundation|bill.*melinda' }
    'emersoncollective' { 'emerson\s*collective' }
    'mitmedialab' { 'mit\s*media\s*lab' }
    default { [regex]::Escape($s) }
  }
  $hit = $cands | Where-Object { $_.Name -match $rx } | Select-Object -First 1
  if ($hit) {
    Copy-Item $hit.FullName (Join-Path $staged ($s + '-candidate' + $hit.Extension.ToLower())) -Force
    $rows += [pscustomobject]@{ slug=$s; candidate=$hit.FullName; ext=$hit.Extension.TrimStart('.'); note='candidate staged' }
  } else {
    $rows += [pscustomobject]@{ slug=$s; candidate=''; ext=''; note='no candidate' }
  }
}
$rows | Export-Csv (Join-Path $logos 'audit.csv') -NoTypeInformation -Encoding UTF8
Write-Host "Refreshed logos audit at $logos\audit.csv; staged: $((Get-ChildItem $staged -File | Measure-Object).Count)"
