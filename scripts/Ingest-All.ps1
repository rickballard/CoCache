param(
  [string]$Downloads    = "$env:USERPROFILE\Downloads",
  [string]$Desktop      = "$env:USERPROFILE\Desktop",
  [string]$CoCacheRoot  = "$env:USERPROFILE\Documents\GitHub\CoCache",
  [string[]]$ServerRoots = @("\\Server\homes\RB\2025 Project InSeed",
                             "\\Server\homes\RB\2025 Project GroupBuild",
                             "\\Server\homes\RB\2025 Project CoCivium Repo"),
  [switch]$IncludeDesktop,
  [switch]$IncludeServer,
  [switch]$DryRun
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
function Ensure-Dir($p){ if(-not (Test-Path $p)){ New-Item -ItemType Directory -Force -Path $p | Out-Null } }
$stack      = Join-Path $CoCacheRoot 'CoWraps\STACK';            Ensure-Dir $stack
$seedVault  = Join-Path $CoCacheRoot 'CoWraps\DESKTOP_SeedVault';Ensure-Dir $seedVault
$imports    = Join-Path $CoCacheRoot 'imports';                  Ensure-Dir $imports
$reportsDir = Join-Path $imports    'Reports';                   Ensure-Dir $reportsDir
$legacyRoot = Join-Path $CoCacheRoot 'private\Legacy';           Ensure-Dir $legacyRoot
function Get-Sha256([string]$path){ $sha=[Security.Cryptography.SHA256]::Create(); $fs=[IO.File]::OpenRead($path); try{ -join ($sha.ComputeHash($fs) | ForEach-Object { $_.ToString('x2') }) } finally { $fs.Dispose(); $sha.Dispose() } }
function Find-SpankyZips($dir){ Get-ChildItem -Path $dir -File -Filter 'Spanky_*.zip' -ErrorAction SilentlyContinue | Where-Object { $_.Name -notmatch '^Spanky_Request_Pack' } | Sort-Object Name }
function Validate-SessionZip($expandedRoot){
  $root = Get-ChildItem -Path $expandedRoot -Directory -Recurse | Where-Object { Test-Path (Join-Path $_.FullName '_spanky') } | Select-Object -First 1
  if(-not $root){ return @{ Ok=$false; Reason='no _spanky folder' } }
  $reqD  = @('_spanky','transcripts','payload','notes','summaries')
  $missD = @($reqD | Where-Object { -not (Test-Path (Join-Path $root.FullName $_)) })
  $mustF = @('_spanky\_copayload.meta.json','_spanky\_wrap.manifest.json','_spanky\out.txt')
  $missF = @($mustF | Where-Object { -not (Test-Path (Join-Path $root.FullName $_)) })
  $countsOk=$true; $statusLine=""
  $outPath = Join-Path $root.FullName '_spanky\out.txt'
  if(Test-Path $outPath){
    $statusLine = (Get-Content $outPath -Raw).Trim()
    $m=[regex]::Matches($statusLine,'items=(\d+).*?transcripts=(\d+).*?payload=(\d+).*?notes=(\d+).*?summaries=(\d+)')
    if($m.Count -gt 0){ $it=[int]$m[0].Groups[1].Value; $t=[int]$m[0].Groups[2].Value; $p=[int]$m[0].Groups[3].Value; $n=[int]$m[0].Groups[4].Value; $s=[int]$m[0].Groups[5].Value; if($it -ne ($t+$p+$n+$s)){ $countsOk=$false } }
  }
  $ok = ($missD.Count -eq 0 -and $missF.Count -eq 0)
  return @{ Ok=$ok; Root=$root; MissingDirs=$missD; MissingFiles=$missF; CountsOK=$countsOk; Status=$statusLine }
}
function Stage-Wrap($rootDir,$destName){
  $stack = Join-Path "$env:USERPROFILE\Documents\GitHub\CoCache" 'CoWraps\STACK'
  $dest = Join-Path $stack $destName
  if(Test-Path $dest){ Remove-Item $dest -Recurse -Force }
  Copy-Item $rootDir -Destination $dest -Recurse -Force
  "# CoWrap placement`nDrop-in: CoCache/CoWraps/STACK/$destName/" | Set-Content (Join-Path $dest 'README_PLACEMENT.md') -Encoding UTF8
  $dest
}
# Phase A: HANDOFF bundle (if any)
$handoff = Get-ChildItem -Path (Join-Path $Downloads 'Spanky_HANDOFF_*.zip') -File -EA SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if($handoff){
  Write-Host "==> HANDOFF: $($handoff.FullName)"
  $tmp = Join-Path $env:TEMP ("SpankyHandoff_" + [Guid]::NewGuid().Guid); Ensure-Dir $tmp
  try{
    Expand-Archive -Path $handoff.FullName -DestinationPath $tmp -Force
    $root = Get-ChildItem -Path $tmp -Directory | Select-Object -First 1
    $zipsDir = Join-Path $root.FullName 'zips'
    $sumFile = Join-Path $root.FullName 'SHA256SUMS.txt'
    $report = @(); $imported=0; $quar=0
    $checks=@{}
    if(Test-Path $sumFile){ (Get-Content $sumFile) | ForEach-Object { if($_ -match '^([0-9a-f]{64})\s+\*(.+)$'){ $checks[$Matches[2]]=$Matches[1] } } }
    foreach($z in (Get-ChildItem -Path $zipsDir -File -EA SilentlyContinue)){
      $ckOK=$true; if($checks.ContainsKey($z.Name)){ $calc=Get-Sha256 $z.FullName; if($calc.ToLower() -ne $checks[$z.Name].ToLower()){ $ckOK=$false } }
      $tmpZ = Join-Path $env:TEMP ("SpChk_" + [Guid]::NewGuid().Guid); New-Item -ItemType Directory -Force -Path $tmpZ | Out-Null
      Expand-Archive -Path $z.FullName -DestinationPath $tmpZ -Force
      $v = Validate-SessionZip $tmpZ
      $disp="import"; $notes=""
      if(-not $ckOK){ $disp="quarantine"; $notes+="checksum mismatch; " }
      if(-not $v.Ok){ $disp="quarantine"; $notes+="missing dirs/files; " }
      if(-not $v.CountsOK){ $notes+="counts mismatch; " }
      if($disp -eq 'import'){
        $meta = Join-Path $v.Root.FullName '_spanky\_copayload.meta.json'
        $name = [IO.Path]::GetFileNameWithoutExtension($z.Name)
        if(Test-Path $meta){ try{ $t=(Get-Content $meta -Raw | ConvertFrom-Json).session_title; if($t -and $t -notmatch '^\s*$'){ $name=(($t -replace '\s+','_') -replace '[^\w\.\-]','_') } }catch{} }
        Stage-Wrap $v.Root.FullName $name | Out-Null; $imported++
      } else { $quar++ }
      $report += [pscustomobject]@{ SessionKey=[IO.Path]::GetFileNameWithoutExtension($z.Name); FileName=$z.Name; ChecksumOK=$ckOK; RequiredFilesOK=$v.Ok; CountsOK=$v.CountsOK; OutTxtStatus=$v.Status; Disposition=$disp; Notes=$notes.Trim() }
      Remove-Item $tmpZ -Recurse -Force -EA SilentlyContinue
    }
    $csv = Join-Path $root.FullName 'Ingest_Report.csv'
    $report | Export-Csv -NoTypeInformation -Path $csv -Encoding UTF8
    Write-Host "INGEST DONE`nimported=$imported  quarantine=$quar`nreport=$csv"
  } finally { Remove-Item $tmp -Recurse -Force -EA SilentlyContinue }
} else { Write-Host "No HANDOFF zip found (ok)." }
# Phase B: loose Spanky_*.zip in Downloads
foreach($zip in (Find-SpankyZips $Downloads)){
  Write-Host "Processing: $($zip.Name)"
  $tmp = Join-Path $env:TEMP ("SpLoose_" + [Guid]::NewGuid().Guid); New-Item -ItemType Directory -Force -Path $tmp | Out-Null
  try{
    Expand-Archive -Path $zip.FullName -DestinationPath $tmp -Force
    $v = Validate-SessionZip $tmp
    if(-not $v.Ok){ Write-Warning "SKIP invalid: $($zip.Name)"; continue }
    $meta = Join-Path $v.Root.FullName '_spanky\_copayload.meta.json'
    $name = [IO.Path]::GetFileNameWithoutExtension($zip.Name)
    if(Test-Path $meta){ try{ $t=(Get-Content $meta -Raw | ConvertFrom-Json).session_title; if($t -and $t -notmatch '^\s*$'){ $name=(($t -replace '\s+','_') -replace '[^\w\.\-]','_') } }catch{} }
    Stage-Wrap $v.Root.FullName $name | Out-Null
  } finally { Remove-Item $tmp -Recurse -Force -EA SilentlyContinue }
}
Write-Host "`nNext: cd `"$CoCacheRoot`"; git add -A; git commit -m 'Ingest: Spanky batch'; git push"
