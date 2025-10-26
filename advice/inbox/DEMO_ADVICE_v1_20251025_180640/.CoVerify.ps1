param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path,
  [string]$Inbox = (Join-Path $Root 'advice\inbox')
)
$ErrorActionPreference='Stop'
function OutMsg($s,$c='Gray'){ Write-Host $s -ForegroundColor $c }

# Locate “latest family” by most recent ts in folder/zip names
$items = Get-ChildItem -File $Inbox -ErrorAction SilentlyContinue
$zips  = $items | Where-Object { $_.Extension -ieq '.zip' }
$mds   = $items | Where-Object { $_.Extension -ieq '.md' }

# Web readability: expanded folders for latest zips are recommended
OutMsg "== .CoVerify: scanning inbox =="
OutMsg ("Files: {0}" -f $items.Count) 'DarkGray'

$problems = @()

# Basic guardrails
foreach($f in $items){
  if($f.Length -gt 256KB){ $problems += "Oversize: $($f.Name) = $([math]::Round($f.Length/1KB)) KB" }
  if($f.Extension -notin '.md','.txt','.json','.zip'){ $problems += "Bad ext: $($f.Name)" }
}

# Required files in a drop (best-effort: look in expanded folders first)
$expanded = Get-ChildItem -Directory $Inbox -ErrorAction SilentlyContinue
$leafs = @()
foreach($d in $expanded){ $leafs += Get-ChildItem -File $d.FullName -Recurse }

$need = @('README.md','Deliverable_Manifest.md','.CoVerify.ps1')
foreach($n in $need){
  if(-not ($leafs + $items | Where-Object { $_.Name -ieq $n })){
    $problems += "Missing required deliverable: $n"
  }
}

if($problems.Count){
  OutMsg "FAIL" 'Red'
  $problems | ForEach-Object { OutMsg " - $_" 'Red' }
  exit 2
}
OutMsg "OK" 'Green'
