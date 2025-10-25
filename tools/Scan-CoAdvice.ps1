param(
  [string]$Root = "$HOME\Documents\GitHub\CoCache",
  [string]$Out  = (Join-Path $Root "status\advice_candidates.json")
)
$ErrorActionPreference='Stop'
function Coalesce([object[]]$v){ foreach($x in $v){ if($null -ne $x -and "$x" -ne ""){ return $x } } return $null }
function Classify-Level([string]$text,[string]$name){
  if($name -match "AdviceBomb" -or $name -match "Deliverable_Manifest" -or $text -match "(CoEvo|Guardrails|Status:\s*(draft|iterating|settled))"){ return "A" }
  if($text -match "(ingest|index|intent|owner|version|^Title:|^Intent:|^Owner:)" -or $name -match "(_|-)v\d+"){ return "B" }
  return "C"
}
$roots = @("advice","docs\intent\advice","docs\intent","docs") | ForEach-Object { Join-Path $Root $_ } | Where-Object { Test-Path $_ } | Select-Object -Unique
$cands = @()
foreach($r in $roots){
  $cands += Get-ChildItem -File -Recurse $r -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch "\\(node_modules|\.git)\\" -and $_.Extension -in ".zip",".md",".txt",".json" }
}
$recs = @()
foreach($f in ($cands | Select-Object -Unique)){
  $name  = $f.Name
  $noExt = [IO.Path]::GetFileNameWithoutExtension($name)
  $fam   = $noExt -replace "([-_]?v\d+(_\d{8}_\d{6})?)$",""
  $ver   = if($noExt -match "[_-]v(\d+)(?:_|$)"){ [int]$matches[1] } else { $null }

  $tsFromName = $null
  if($name -match "_(\d{8})_(\d{6})"){ $tsFromName = [datetime]::ParseExact(($matches[1]+" "+$matches[2]),"yyyyMMdd HHmmss",$null) }

  $repo = (Resolve-Path -LiteralPath $Root).Path
  $rel  = (Resolve-Path -LiteralPath $f.FullName).Path.Substring($repo.Length).TrimStart("\").Replace("\","/")
  $dates = if($env:CO_SKIP_GIT){$null}else{ & git -C $Root log --follow --format="%ad" --date=iso-strict -- "$rel" 2>$null }
  $first = if($dates){ [datetime]($dates | Select-Object -Last 1) } else { $null }
  $last  = if($dates){ [datetime]($dates | Select-Object -First 1) } else { $null }

  $peek = ""
  if($f.Length -lt 512KB -and $f.Extension -in ".md",".txt",".json"){ try{ $peek = (Get-Content $f.FullName -Raw -EA SilentlyContinue) }catch{} }

  $lvl = Classify-Level $peek $name
  $stamp = Coalesce @($tsFromName,$first,$f.LastWriteTime)

  $recs += [pscustomobject]@{
    path=$rel; sizeKB=[math]::Round($f.Length/1KB); family=$fam; version=$ver
    firstCommit=$first; lastCommit=$last; stamp=$stamp; level=$lvl; ext=$f.Extension
  }
}
New-Item -ItemType Directory -Force -Path (Split-Path $Out) | Out-Null
$recs | ConvertTo-Json -Depth 6 | Set-Content -Encoding utf8 $Out
Write-Host "Wrote candidate report: $Out" -ForegroundColor Cyan
Write-Host ("Counts by level: " + (($recs | Group-Object level | ForEach-Object { "{0}:{1}" -f $_.Name,$_.Count }) -join ", "))

