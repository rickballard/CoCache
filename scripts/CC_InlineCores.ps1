\
param(
  [string]$Repo = (git rev-parse --show-toplevel 2>$null)
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

if(-not $Repo){
  $fallback = Join-Path $HOME "Documents\GitHub\CoCache"
  if(Test-Path $fallback){ $Repo = $fallback } else { throw "Repo not found; run inside your repo." }
}
Set-Location $Repo

$ccFile  = Join-Path $Repo "CC\..CC_Megascroll_SEED.md"
$prFile  = Join-Path $Repo "PRINCIPLES\.PRINCIPLES_CoCivium_SEED.md"
$bpoe    = Join-Path $Repo "BPOE\_BPOE_Wisdom_Human-Limits_And_Ops.md"

if(-not (Test-Path $ccFile)){ throw "Megascroll seed not found: $ccFile" }
if(-not (Test-Path $prFile)){ throw "Principles seed not found: $prFile" }
if(-not (Test-Path $bpoe)){ throw "BPOE doc not found: $bpoe" }

$cc  = Get-Content -Raw -LiteralPath $ccFile
$pr  = Get-Content -Raw -LiteralPath $prFile
$bw  = Get-Content -Raw -LiteralPath $bpoe

function Get-Section {
  param([string]$Text,[string]$Heading)  # Heading text after '## '
  $pattern = "(?smi)^\s*##\s+$([regex]::Escape($Heading)).*?(?=^\s*##\s+|\Z)"
  $m = [regex]::Match($Text,$pattern)
  if($m.Success){ return $m.Value.Trim() } else { return $null }
}

$pillars   = Get-Section $pr "Pillars"
$guardrails= Get-Section $pr "Guardrails"

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$header = @"
<!-- BEGIN:INLINED_CORES -->
<!-- auto-generated @ $timestamp -->
## Core Principles (excerpt)

$pillars

$guardrails

## BPOE: Human Limits (core)
$bw
<!-- END:INLINED_CORES -->
"@

# place or replace
if($cc -match "(?s)<!-- BEGIN:INLINED_CORES -->.*?<!-- END:INLINED_CORES -->"){
  $cc2 = [regex]::Replace($cc,"(?s)<!-- BEGIN:INLINED_CORES -->.*?<!-- END:INLINED_CORES -->",$header)
} else {
  # insert after 'Support Scroll Cores' section if present, else append
  if($cc -match "(?s)(#\s*Support\s+Scroll\s+Cores.*)"){
    $cc2 = $cc -replace "(?s)(<!-- END:INLINED_CORES -->)?\s*$","`r`n$header`r`n"
  } else {
    $cc2 = $cc + "`r`n`r`n" + $header + "`r`n"
  }
}

if($cc2 -ne $cc){
  Set-Content -LiteralPath $ccFile -Value $cc2 -Encoding UTF8
  "Megascroll updated."
} else {
  "Megascroll already up to date."
}
