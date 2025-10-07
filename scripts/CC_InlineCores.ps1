# CC_InlineCores.ps1 — inline core excerpts into megascroll
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$Megascroll,
  [Parameter(Mandatory=$true)][string]$Principles,
  [Parameter(Mandatory=$true)][string]$Bpoe
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Read-AllText([string]$path){
  return Get-Content -LiteralPath $path -Raw -Encoding UTF8
}

function Extract-Section([string]$text,[string]$h){
  $p = "(?ms)^\s*##\s+" + [regex]::Escape($h) + "\s*\r?\n(.*?)(?=^\s*##\s+|\Z)"
  $m = [regex]::Match($text,$p)
  if($m.Success){ return $m.Groups[1].Value.Trim() } else { return "" }
}

# Load sources
$megaText = Read-AllText $Megascroll
$prText   = Read-AllText $Principles
$bpText   = Read-AllText $Bpoe

# Compose excerpt block
$parts = @()

# From PRINCIPLES
$secPillars    = Extract-Section $prText "Pillars"
$secGuardrails = Extract-Section $prText "Guardrails"
if($secPillars){   $parts += "# Core Principles — Pillars`r`n$secPillars" }
if($secGuardrails){$parts += "# Core Principles — Guardrails`r`n$secGuardrails" }

# From BPOE
$secCD = Extract-Section $bpText "Cool-Down Trigger"
$secRE = Extract-Section $bpText "Re-Entry Checklist"
if($secCD){ $parts += "# BPOE — Cool-Down Trigger`r`n$secCD" }
if($secRE){ $parts += "# BPOE — Re-Entry Checklist`r`n$secRE" }

$block = "<!-- BEGIN:CORE_EXCERPTS -->`r`n" + ($parts -join "`r`n`r`n") + "`r`n<!-- END:CORE_EXCERPTS -->"

# Replace between markers (create markers if missing)
if($megaText -notmatch "<!--\s*BEGIN:CORE_EXCERPTS\s*-->"){
  $megaText = $megaText + "`r`n`r`n" + $block
} else {
  $megaText = [regex]::Replace(
    $megaText,
    "(?s)<!--\s*BEGIN:CORE_EXCERPTS\s*-->.*?<!--\s*END:CORE_EXCERPTS\s*-->",
    [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $block }
  )
}

# Save
Set-Content -LiteralPath $Megascroll -Value $megaText -Encoding UTF8
Write-Host "Megascroll updated."
