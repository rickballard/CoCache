Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Info($m){ Write-Host "[INFO] $m" -ForegroundColor Cyan }
function Warn($m){ Write-Host "[WARN] $m" -ForegroundColor Yellow }
function Die($m){ Write-Error $m; exit 1 }

param(
  [switch]$SkipCoRender,
  [switch]$SkipCoRef,
  [switch]$SkipDoctrine,
  [switch]$SkipGodspawnP3,
  [switch]$SkipPing
)

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$payload = Join-Path $here "payload"
$dl = Join-Path $env:USERPROFILE "Downloads"

# Start transcript
$log = Join-Path $dl ("CoSuite_MegaDeploy_" + (Get-Date -Format 'yyyyMMdd_HHmmss') + ".log")
try { Start-Transcript -Path $log -Force | Out-Null } catch {}

Info "Copying payloads to Downloads…"
$files = @(
  "CoRender_Fallbacks_AdviceBomb_v0.2.1.zip",
  "Deploy-CoRender-To-Repos_v0.2.1.ps1",
  "CoRef_ConceptFirst_AdviceBomb_v0.3.0.zip",
  "Deploy-CoRef-To-Repos_v0.3.0.ps1",
  "CoCongruence_Doctrine_Pack_v0.1.0.zip",
  "Deploy-CoCongruence-To-CoCivium_v0.1.1.ps1",
  "Godspawn_Part3_AdviceBomb_v0.1.0.zip",
  "Deploy-Godspawn-P3-Advice_v0.1.0.ps1",
  "Trigger-CoRender-Ping.ps1"
)
foreach($f in $files){
  Copy-Item -Path (Join-Path $payload $f) -Destination (Join-Path $dl $f) -Force
}

function Run-Step($name, [scriptblock]$block){
  Info ("==> " + $name)
  try {
    & $block
    Info ("<== " + $name + " [OK]")
  } catch {
    Write-Host ("[ERROR] " + $name + ": " + $_.Exception.Message) -ForegroundColor Red
    throw
  }
  Start-Sleep -Seconds 2
}

# 1) CoRender CI + hooks
if(-not $SkipCoRender){
  Run-Step "CoRender (CI hooks + workflow)" {
    & (Join-Path $dl "Deploy-CoRender-To-Repos_v0.2.1.ps1")
  }
}

# 2) CoRef indexing standards + exemplar
if(-not $SkipCoRef){
  Run-Step "CoRef (indexing standards + exemplar)" {
    & (Join-Path $dl "Deploy-CoRef-To-Repos_v0.3.0.ps1")
  }
}

# 3) Congruence Doctrine seed
if(-not $SkipDoctrine){
  Run-Step "Congruence Doctrine seed" {
    & (Join-Path $dl "Deploy-CoCongruence-To-CoCivium_v0.1.1.ps1")
  }
}

# 4) Godspawn Part 3 advice
if(-not $SkipGodspawnP3){
  Run-Step "Godspawn Part 3 advice" {
    & (Join-Path $dl "Deploy-Godspawn-P3-Advice_v0.1.0.ps1")
  }
}

# 5) Optional: CoRender ping branch
if(-not $SkipPing){
  Run-Step "Trigger CoRender Ping (PR optional)" {
    & (Join-Path $dl "Trigger-CoRender-Ping.ps1")
  }
}

Info "All steps done. Logs at $log"
try { Stop-Transcript | Out-Null } catch {}
