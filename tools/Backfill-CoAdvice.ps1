param(
  [string]$Root = "$HOME\Documents\GitHub\CoCache",
  [switch]$DoIngest,
  [switch]$NoDryRun,
  [string[]]$Families,
  [string[]]$Exclude
)
$ErrorActionPreference = "Stop"
function P($s,$c="Gray"){ Write-Host $s -ForegroundColor $c }
function Coalesce([object[]]$v){ foreach($x in $v){ if($null -ne $x -and "$x" -ne ""){ return $x } } return $null }

$Inbox     = Join-Path $Root "advice\inbox"
$Tools     = Join-Path $Root "tools"
$DoMerge   = Join-Path $Tools "DO-AdviceBomb-Merge.ps1"
$CoVerify  = Join-Path $Inbox ".CoVerify.ps1"

New-Item -ItemType Directory -Force -Path $Inbox,$Tools | Out-Null
if(!(Test-Path $DoMerge)){ throw "Missing: $DoMerge (ensure tools/DO-AdviceBomb-Merge.ps1 exists)" }
if(!(Test-Path $CoVerify)){
@"
param([string]$Root=(Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path,[string]$Inbox=(Join-Path $Root 'advice\inbox'))
$ErrorActionPreference='Stop'
function OutMsg(\$s,\$c='Gray'){ Write-Host \$s -ForegroundColor \$c }
\$items=@(Get-ChildItem -File \$Inbox -ErrorAction SilentlyContinue)
\$problems=@()
foreach(\$f in \$items){
  if(\$f.Length -gt 256KB){ \$problems+="Oversize: \$(\$f.Name)" }
  \$okExt='.md','.txt','.json','.zip'
  if(\$f.Name -ieq '.CoVerify.ps1'){ \$ok=\$true } else { \$ok=\$okExt -contains \$f.Extension.ToLowerInvariant() }
  if(-not \$ok){ \$problems+="Bad ext: \$(\$f.Name)" }
}
\$expanded=@(Get-ChildItem -Directory \$Inbox -ErrorAction SilentlyContinue)
\$leafs=@(); foreach(\$d in \$expanded){ \$leafs+=Get-ChildItem -File \$d.FullName -Recurse -ErrorAction SilentlyContinue }
\$need=@('README.md','Deliverable_Manifest.md','.CoVerify.ps1')
foreach(\$n in \$need){ if(-not (\$leafs+\$items | Where-Object { \$_.Name -ieq \$n })){ \$problems+="Missing required deliverable: \$n" } }
if(\$problems.Count){ OutMsg 'FAIL' 'Red'; \$problems|%{OutMsg " - \$_" 'Red'}; exit 2 } else { OutMsg 'OK' 'Green' }
"@ | Set-Content -Encoding utf8 $CoVerify
}

Add-Type -AssemblyName System.IO.Compression.FileSystem

$candidateFiles = @()
$searchRoots = @(
  (Join-Path $Root "advice"),
  (Join-Path $Root "docs\intent\advice"),
  (Join-Path $Root "docs\intent"),
  (Join-Path $Root "docs")
) | ? { Test-Path $_ } | Select-Object -Unique

foreach($r in $searchRoots){
  $candidateFiles += Get-ChildItem -File -Recurse $r -EA SilentlyContinue |
    ? {
      $_.FullName -notmatch "\\(node_modules|\.git)\\" -and
      ($_.Extension -in ".zip",".md",".txt",".json") -and
      ($_.Name -match "(_|-)v\d+" -or $_.Name -match "AdviceBomb" -or $_.Name -match "Manifest" -or $_.DirectoryName -match "advice")
    }
}
$candidateFiles = $candidateFiles | Select-Object -Unique

function Get-FVT($file){
  $name  = $file.Name
  $noExt = [IO.Path]::GetFileNameWithoutExtension($name)
  $family = $noExt -replace "([-_]?v\d+(_\d{8}_\d{6})?)$",""
  $version = $null
  if($noExt -match "[_-]v(\d+)(?:_|$)"){ $version = [int]$matches[1] }
  $tsFromName = $null
  if($name -match "_(\d{8})_(\d{6})"){ $tsFromName = [datetime]::ParseExact(($matches[1]+" "+$matches[2]),"yyyyMMdd HHmmss",$null) }
  $repo = (Resolve-Path -LiteralPath $Root).Path
  $rel  = (Resolve-Path -LiteralPath $file.FullName).Path.Substring($repo.Length).TrimStart("\").Replace("\","/")
  $dates = & git -C $Root log --follow --format="%ad" --date=iso-strict -- "$rel" 2>$null
  $tsGit = if($dates){ try{ [datetime]($dates | Select-Object -Last 1) }catch{ $null } } else { $null }
  $ts    = Coalesce @($tsFromName,$tsGit,$file.LastWriteTime)
  if(-not $version){ $version = 1 }
  if(-not $family -or "$family" -eq ""){ $family = $noExt }
  [pscustomobject]@{ Family=$family; Version=[int]$version; StampDT=[datetime]$ts }
}

$plan = @{}
foreach($f in $candidateFiles){
  $fvt = Get-FVT $f
  if(-not $fvt){ continue }
  $key = "{0}|v{1}|{2:yyyyMMdd_HHmmss}" -f $fvt.Family,$fvt.Version,$fvt.StampDT
  if(-not $plan.ContainsKey($key)){
    $plan[$key] = [pscustomobject]@{
      Family  = $fvt.Family
      Version = $fvt.Version
      StampDT = $fvt.StampDT
      Files   = New-Object System.Collections.Generic.List[System.IO.FileInfo]
    }
  }
  $plan[$key].Files.Add($f)
}

$work = $plan.GetEnumerator() | % { $_.Value } | Sort-Object Family, StampDT, Version
if($Families){ $famSet = $Families | % { $_.ToLower() }; $work = $work | ? { $famSet -contains $_.Family.ToLower() } }
if($Exclude){  $excSet = $Exclude  | % { $_.ToLower() }; $work = $work | ? { $excSet -notcontains $_.Family.ToLower() } }
if(-not $work.Count){ P "No legacy advice-like artifacts found to backfill (after filters)." "Yellow"; return }
P ("Backfill candidates (post-filter): {0}" -f $work.Count) "Cyan"

$created = @()
foreach($w in $work){
  $topic   = $w.Family -replace "\s+","_"
  $ver     = $w.Version
  $stamp   = $w.StampDT.ToString("yyyyMMdd_HHmmss")
  $stamp2  = $w.StampDT.ToString("yyyy-MM-ddTHH-mm-ss")
  $zipBase = "{0}_v{1}_{2}" -f $topic,$ver,$stamp
  $expDir  = Join-Path $Inbox $zipBase
  $zipPath = Join-Path $Inbox ($zipBase + ".zip")

  if ( (Test-Path $zipPath) -or (Test-Path $expDir) ){
    P ("skip  {0} (already present)" -f $zipBase) "DarkGray"
    continue
  }

  P ("make  {0}" -f $zipBase) "Green"
  if(-not $NoDryRun){ continue }   # preview only

  New-Item -ItemType Directory -Force -Path $expDir | Out-Null

@"
Title: $topic
Intent: Backfilled legacy advice
Owner: Backfill
Version: $stamp2
Status: settled
Guardrails:
  MaxSizeKB: 256
  MaxCadenceMins: 30
  MaxChangePct: 20
Change-Notes:
  - Backfilled from legacy content; preserved original timestamp

## Source Files
$(($w.Files | % { "- " + ($_.FullName.Substring((Resolve-Path $Root).Path.Length).TrimStart("\") ) }) -join "`r`n"))
"@ | Set-Content -Encoding utf8 (Join-Path $expDir "README.md")

@"
filename: $($zipBase).zip
version: v$ver
timestamp: $stamp
source_session: Backfill
target_session: CoPrime
status: ready-for-ingestion
"@ | Set-Content -Encoding utf8 (Join-Path $expDir "Deliverable_Manifest.md")

  Copy-Item -Force $CoVerify (Join-Path $expDir ".CoVerify.ps1")

  foreach($sf in $w.Files){
    if($sf.Extension -in ".md",".txt",".json"){
      Copy-Item -Force $sf.FullName (Join-Path $expDir $sf.Name)
    } elseif($sf.Extension -eq ".zip") {
      try{
        $tmp = Join-Path $expDir ("_unzipped_" + [IO.Path]::GetFileNameWithoutExtension($sf.Name))
        New-Item -ItemType Directory -Force -Path $tmp | Out-Null
        [IO.Compression.ZipFile]::ExtractToDirectory($sf.FullName,$tmp)
      }catch{
        P ("warn  failed to extract {0}: {1}" -f $sf.Name,$_.Exception.Message) "Yellow"
      }
    }
  }

  if(Test-Path $zipPath){ Remove-Item -Force $zipPath }
  [IO.Compression.ZipFile]::CreateFromDirectory($expDir,$zipPath)
  try{ (Get-Item $zipPath).LastWriteTime = $w.StampDT } catch {}
  try{ (Get-Item $expDir ).LastWriteTime = $w.StampDT } catch {}

  $created += [pscustomobject]@{ Family=$topic; Version=$ver; Stamp=$stamp; Zip=$zipPath; Dir=$expDir }
}

if($created.Count){
  P "Created bundles:" "Cyan"
  $created | % { P (" - {0} (v{1}, {2})" -f $_.Family,$_.Version,$_.Stamp) "Gray" }
}else{
  P "No new bundles created (dry-run or already present)." "Yellow"
}

if($NoDryRun -and (Test-Path $CoVerify)){
  P "Running .CoVerify on inbox..." "Gray"
  & $CoVerify | Out-Host
}

if($DoIngest -and $NoDryRun){
  $order = $created | Sort-Object { $_.Stamp }
  $families = $order | Select-Object -Expand Family -Unique
  foreach($fam in $families){
    P ("INGEST {0}" -f $fam) "Cyan"
    & $DoMerge -Root $Root -Family $fam | Out-Host
  }
  P "Backfill ingest complete." "Green"
} elseif($created.Count -and $NoDryRun){
  P "Next step: ingest created families (chronological) with:" "Gray"
  $cmd = "& `"$DoMerge`" -Root `"$Root`" -Family `"<FAMILY>`""
  P "  $cmd" "Gray"
}
