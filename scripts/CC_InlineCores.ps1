
param(
  [string]$Repo = ".",
  [string]$Megascroll = "CC\..CC_Megascroll_SEED.md",
  [string]$Principles = "PRINCIPLES\.PRINCIPLES_CoCivium_SEED.md",
  [string]$Bpoe = "BPOE\_BPOE_Wisdom_Human-Limits_And_Ops.md"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Get-LinesNoFrontmatter {
  param([string]$Path)
  $t = Get-Content -LiteralPath $Path -Raw -ErrorAction Stop
  $lines = $t -split "`r?`n"
  if($t -match '^(?ms)^---\s*?\n.*?\n---\s*?\n'){
    $after = $t -replace '^(?ms)^---\s*?\n.*?\n---\s*?\n', ''
    return $after -split "`r?`n"
  }
  return $lines
}

function Get-Section {
  param([string[]]$Lines,[string]$Heading)
  $idx = ($Lines | Select-String -Pattern "^[\s#]*##\s+$([regex]::Escape($Heading))\b" -AllMatches).Matches | ForEach-Object { $_.LineNumber } | Select-Object -First 1
  if(-not $idx){ return $null }
  $start = [int]$idx
  $next  = ($Lines | Select-String -Pattern "^[\s#]*##\s+" -AllMatches).Matches |
           Where-Object { $_.LineNumber -gt $start } |
           Select-Object -First 1
  $end = if($next){ [int]$next.LineNumber - 1 } else { $Lines.Count }
  return $Lines[($start-1)..($end-1)]
}

$repoRoot = (Resolve-Path $Repo).Path
$megap    = Join-Path $repoRoot $Megascroll
$ppath    = Join-Path $repoRoot $Principles
$bpath    = Join-Path $repoRoot $Bpoe

if(-not (Test-Path $megap)){ throw "Megascroll not found: $Megascroll" }
if(-not (Test-Path $ppath)){ throw "Principles not found: $Principles" }
if(-not (Test-Path $bpath)){ throw "BPOE not found: $Bpoe" }

$megLines = Get-Content -LiteralPath $megap -Raw -ErrorAction Stop -Encoding UTF8 -ea Stop -TotalCount 999999
$megArr   = $megLines -split "`r?`n"

$pl = Get-LinesNoFrontmatter -Path $ppath
$bl = Get-LinesNoFrontmatter -Path $bpath

$p_pillars   = Get-Section -Lines $pl -Heading "Pillars"
$p_guardrail = Get-Section -Lines $pl -Heading "Guardrails"
if(-not $p_pillars){ $p_pillars = $pl }
if(-not $p_guardrail){ $p_guardrail = @() }

$b_cool = Get-Section -Lines $bl -Heading "Cool-Down Trigger"
$b_re   = Get-Section -Lines $bl -Heading "Re-Entry Checklist"
if(-not $b_cool){ $b_cool = $bl }

$excerpt = @()
$excerpt += "<!-- BEGIN:CORE_EXCERPTS -->"
$excerpt += "## Core Principles (excerpt)"
$excerpt += ($p_pillars + '')
if($p_guardrail.Count -gt 0){
  $excerpt += ""
  $excerpt += "### Guardrails (excerpt)"
  $excerpt += ($p_guardrail + '')
}
$excerpt += ""
$excerpt += "## BPOE Human Limits (excerpt)"
$excerpt += ($b_cool + '')
if($b_re.Count -gt 0){
  $excerpt += ""
  $excerpt += "### Re-Entry Checklist (excerpt)"
  $excerpt += ($b_re + '')
}
$excerpt += "<!-- END:CORE_EXCERPTS -->"

$beginIdx = ($megArr | Select-String -Pattern '<!--\s*BEGIN:CORE_EXCERPTS\s*-->' -AllMatches).Matches | ForEach-Object { $_.LineNumber } | Select-Object -First 1
$endIdx   = ($megArr | Select-String -Pattern '<!--\s*END:CORE_EXCERPTS\s*-->'   -AllMatches).Matches | ForEach-Object { $_.LineNumber } | Select-Object -First 1

if($beginIdx -and $endIdx -and $endIdx -gt $beginIdx){
  $newMeg = @()
  $newMeg += $megArr[0..($beginIdx-2)]
  $newMeg += $excerpt
  if($endIdx -lt $megArr.Count){
    $newMeg += $megArr[$endIdx..($megArr.Count-1)]
  }
  $out = ($newMeg -join "`r`n")
} else {
  $out = ($megArr + @("", "") + $excerpt) -join "`r`n"
}

Set-Content -LiteralPath $megap -Value $out -Encoding UTF8
Write-Host "Megascroll updated." -ForegroundColor Green
