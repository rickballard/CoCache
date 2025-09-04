param(
  [string]$RepoRoot = ".",
  [string]$Stamp    = (Get-Date -Format "yyMMdd"),
  [int]   $WarnLines = 2000,
  [int]   $WarnFiles = 25,
  [long]  $WarnStageMB = 20
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$root      = (Resolve-Path $RepoRoot).Path
$indexDir  = Join-Path $root 'index'
$reports   = Join-Path $root 'reports'
$icDir     = Join-Path $root ("intake\ideacards\session_{0}" -f $Stamp)
$cwDir     = Join-Path $root ("intake\cowraps\session_{0}"   -f $Stamp)
$stageRaw  = Join-Path $root ("intake\staging\session_{0}\raw" -f $Stamp)
$mapPath   = Join-Path $root ("index\INTAKE_MAP_session_{0}.tsv" -f $Stamp)
$logPath   = Join-Path $reports ("BPOE_ERRORS_{0}.ndjson" -f (Get-Date -Format 'yyyyMMdd'))
$null = New-Item -ItemType Directory -Force -Path $indexDir,$reports -ErrorAction SilentlyContinue

function Sum-Lines($folder){
  if (-not (Test-Path $folder)) { return 0 }
  $files = Get-ChildItem $folder -Filter *.md -File -Recurse -EA SilentlyContinue
  ($files | ForEach-Object {
    try { (Get-Content $_.FullName -EA Stop | Measure-Object -Line).Lines } catch { 0 }
  } | Measure-Object -Sum).Sum
}

$icCount = @(Get-ChildItem $icDir -File -EA SilentlyContinue).Count
$cwCount = @(Get-ChildItem $cwDir -File -EA SilentlyContinue).Count
$mdFiles = $icCount + $cwCount
$mdLines = (Sum-Lines $icDir) + (Sum-Lines $cwDir)

$stageBytes = 0L
if (Test-Path $stageRaw){
  $stageBytes = (Get-ChildItem $stageRaw -File -Recurse -EA SilentlyContinue | Measure-Object -Sum Length).Sum
}
$stageMB   = [math]::Round(($stageBytes / 1MB),2)

$errCount = 0
if (Test-Path $logPath){
  $errCount = (Get-Content $logPath -EA SilentlyContinue |
               Where-Object { $_ -match '\S' } |
               Measure-Object).Count
}
$mapOk = Test-Path $mapPath

# crude loop heuristic
$loopWarn = $false
if ($errCount -gt 0) {
  try {
    $msgs = Get-Content $logPath -EA Stop | ConvertFrom-Json | Select-Object -ExpandProperty message
    $top  = $msgs | Group-Object | Sort-Object Count -Desc | Select-Object -First 1
    if ($top.Count -ge 3) { $loopWarn = $true }
  } catch { }
}

$bloatLevel = if ($mdLines -gt $WarnLines -or $mdFiles -gt $WarnFiles -or $stageMB -gt $WarnStageMB) { "WARN" } else { "OK" }
$loopLevel  = if ($loopWarn) { "WARN" } else { "OK" }
$errLevel   = if ($errCount -gt 0) { "WARN" } else { "OK" }

function Icon($lvl){ switch($lvl){ 'OK' {'✅'} 'WARN' {'🟡'} default {'🔴'} } }
$line = "OE: bloat {0} {1} • loop {2} {3} • errors {4} {5} • files {6} (IC {7}, CW {8}) • stage {9} MB • map {10}" -f `
        (Icon $bloatLevel), $bloatLevel, (Icon $loopLevel), $loopLevel, (Icon $errLevel), $errLevel, `
        $mdFiles, $icCount, $cwCount, $stageMB, ($(if($mapOk){'✅'}else{'🔴'}))

# Write artifacts
$jsonPath = Join-Path $indexDir 'OE_STATUS.json'
$mdPath   = Join-Path $indexDir 'OE_STATUS.md'
@{ ts=(Get-Date).ToString('o'); session=$Stamp; metrics=@{
     md_files=$mdFiles; md_lines=$mdLines; stage_mb=$stageMB; ic=$icCount; cw=$cwCount; bpoe_errors=$errCount; map_exists=$mapOk
   }; status=@{ bloat=$bloatLevel; loop=$loopLevel; errors=$errLevel } } |
  ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 $jsonPath

@(
  '# OE Status', '', '```text', $line, '```', '',
  '| KPI | Status |','|---|---|',
  ('| Bloat | {0} |' -f $bloatLevel),
  ('| Loop  | {0} |' -f $loopLevel ),
  ('| Errors| {0} |' -f $errLevel ),
  '',
  '> Auto-generated. Thresholds: lines>{0} or files>{1} or stage>{2}MB.' -f $WarnLines,$WarnFiles,$WarnStageMB
) -join "`n" | Set-Content -Encoding UTF8 $mdPath

Write-Host $line
