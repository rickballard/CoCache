# Produces Mermaid graph of XREF relations found in repo
param([string]$Root=".", [string]$Out="docs/bpoe/xref-graph.mmd")
$ErrorActionPreference='Stop'
$files = Get-ChildItem -Path $Root -Recurse -File -Include *.md,*.ps1 -ErrorAction SilentlyContinue
$edges = New-Object System.Collections.Generic.List[string]
foreach($f in $files){
  $txt = Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue
  $m = [regex]::Match($txt, '(?s)<!--\s*XREF\b\s*(?<json>{.*?})\s*XREF\s*-->')
  if(!$m.Success){ continue }
  try { $j = $m.Groups['json'].Value | ConvertFrom-Json } catch { continue }
  $from = ($f.FullName -replace [regex]::Escape((Resolve-Path $Root)), '').TrimStart('\','/').Replace('\','/')
  foreach($d in @($j.depends_on)){ if($d){ $edges.Add( ("  `"+$from+"` --> `"+$d+"`") ) } }
  foreach($s in @($j.see_also)){ if($s){ $edges.Add( ("  `"+$from+"` -.-> `"+$s+"`") ) } }
}
$mm = @()
$mm += "%% Auto-generated — asset cross references"
$mm += "graph LR"
$mm += ($edges | Sort-Object -Unique)
$dir = Split-Path -Parent $Out
if($dir){ New-Item -Force -ItemType Directory $dir | Out-Null }
Set-Content -Path $Out -Value ($mm -join "`n") -Encoding UTF8
Write-Host "Mermaid graph written: $Out"
# The above is Python; convert in PowerShell block below when running in GH.