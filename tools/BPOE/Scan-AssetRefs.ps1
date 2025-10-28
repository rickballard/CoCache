# Scan-AssetRefs.ps1 — Build & validate cross-references between assets
# Usage:
#   pwsh -File tools/BPOE/Scan-AssetRefs.ps1 [-Root <path>] [-FailOnErrors]
param(
  [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path,
  [switch]$FailOnErrors
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$markers = @{
  start = '<!-- XREF'
  end   = 'XREF -->'
}

$include = @('*.ps1','*.psm1','*.psd1','*.md','*.yml','*.yaml')
$excludeDirs = @('.git','node_modules','dist','bin','obj','coverage','.venv','.tox')

function Get-RelPath($root, $full) {
  return ($full -replace [regex]::Escape($root), '').TrimStart('\','/').Replace('\','/')
}

function Read-XrefBlock {
  param([string]$text)
  $startIdx = $text.IndexOf($markers.start, [StringComparison]::OrdinalIgnoreCase)
  if($startIdx -lt 0){ return $null }
  $endIdx = $text.IndexOf($markers.end, $startIdx, [StringComparison]::OrdinalIgnoreCase)
  if($endIdx -lt 0){ return $null }
  $block = $text.Substring($startIdx, $endIdx + $markers.end.Length - $startIdx)
  # Extract JSON between lines
  $lines = $block -split "`r?`n"
  $json = ($lines | Where-Object { ($_ -notmatch '<!--') -and ($_ -notmatch '-->') } ) -join "`n"
  try {
    return ($json | ConvertFrom-Json)
  } catch {
    return $null
  }
}

function New-Node($path, $meta) {
  return [pscustomobject]@{
    id = $path
    title = if($meta.title){ $meta.title } else { $path }
    type = $meta.type ?? ""
    repo = $meta.repo ?? ""
    tags = @($meta.tags) | Where-Object { $_ } 
  }
}

$root = (Resolve-Path $Root).Path
$files = Get-ChildItem -Path $root -Recurse -File -Include $include | Where-Object {
  $p = $_.FullName
  -not ($excludeDirs | Where-Object { $p -match [regex]::Escape([IO.Path]::DirectorySeparatorChar + $_ + [IO.Path]::DirectorySeparatorChar) })
}

$nodes = @{}       # path -> node
$edges = @()       # @{ from=path; to=path; kind="depends_on" | "see_also" }
$warnings = New-Object System.Collections.Generic.List[string]

foreach($f in $files){
  $rel = Get-RelPath $root $f.FullName
  $txt = Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue
  $meta = Read-XrefBlock -text $txt
  if(-not $meta){ continue }
  $nodes[$rel] = New-Node -path $rel -meta $meta
  foreach($dep in @($meta.depends_on)){
    if([string]::IsNullOrWhiteSpace($dep)){ continue }
    $edges += [pscustomobject]@{ from=$rel; to=$dep; kind='depends_on' }
  }
  foreach($see in @($meta.see_also)){
    if([string]::IsNullOrWhiteSpace($see)){ continue }
    $edges += [pscustomobject]@{ from=$rel; to=$see; kind='see_also' }
  }
}

# Best-effort reciprocity heuristic: if A depends_on B, suggest B see_also A (warning if absent)
$edgeLookup = $edges | Group-Object { "$($_.from) -> $($_.to) :: $($_.kind)" } | ForEach-Object { $_.Group }
function Has-Edge($from,$to,$kind){ return $edgeLookup.ContainsKey("$from -> $to :: $kind") }

foreach($e in $edges | Where-Object { $_.kind -eq 'depends_on' }){
  if(-not (Has-Edge -from $e.to -to $e.from -kind 'see_also')){
    $warnings.Add("Reciprocity: '$($e.from)' depends_on '$($e.to)' but reverse see_also not found.")
  }
}

$outDir = Join-Path $root 'public\bpoe'
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$graph = [pscustomobject]@{
  generated_utc = (Get-Date).ToUniversalTime().ToString('o')
  nodes = @($nodes.Values | Sort-Object id)
  edges = @($edges)
  warnings = @($warnings)
}

$graphPath = Join-Path $outDir 'ASSET_GRAPH.json'
$graph | ConvertTo-Json -Depth 10 | Set-Content -Encoding UTF8 $graphPath

# Write a human summary (markdown)
$md = @()
$md += "# Asset Cross-Reference Report"
$md += ""
$md += "*Generated:* $($graph.generated_utc)  "
$md += "*Nodes:* $($graph.nodes.Count)  *Edges:* $($graph.edges.Count)  *Warnings:* $($graph.warnings.Count)"
$md += ""
$md += "## Warnings"
if($warnings.Count -gt 0){
  foreach($w in $warnings){ $md += "- $w" }
}else{
  $md += "- _None_"
}
$md += ""
$md += "## Nodes"
foreach($n in ($nodes.Values | Sort-Object id)){
  $tagStr = if($n.tags){ ($n.tags -join ', ') } else { '—' }
  $md += "- `$($n.id)` — **$($n.title)** (type: $($n.type), tags: $tagStr)"
}
$mdPath = Join-Path $outDir 'ASSET_GRAPH.md'
$md -join "`n" | Set-Content -Encoding UTF8 $mdPath

Write-Host "Wrote: $graphPath"
Write-Host "Wrote: $mdPath"

if($FailOnErrors -and $warnings.Count -gt 0){
  Write-Error "Asset xref warnings present ($($warnings.Count))."
}
