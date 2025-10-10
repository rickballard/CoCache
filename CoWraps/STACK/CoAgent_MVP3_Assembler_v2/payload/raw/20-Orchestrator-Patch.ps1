Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$wt = Get-ChildItem "$HOME\Documents\GitHub\CoAgent__mvp3*" -Directory -ErrorAction SilentlyContinue |
      Sort-Object LastWriteTime -Desc | Select-Object -First 1
if(-not $wt){ Write-Host "[20-Orch] Skipped (worktree not found)"; return }
$orch = Join-Path $wt.FullName 'tools\Start-MVP3-Orchestrator.ps1'
Write-Host "[20-Orch] Target: $orch"
if(-not (Test-Path $orch)){ Write-Host "[20-Orch] Skipped (file not found)"; return }
$txt = Get-Content -LiteralPath $orch -Raw
$before = $txt
$session = $env:COAGENT_SESSION_URL
if(-not $session){ Write-Host "[20-Orch] Env COAGENT_SESSION_URL not set; leaving file unchanged."; return }
$pairKey = ($session -replace '[^\w-]','_' -replace '_{2,}','_')
$txt = $txt -replace "'REPLACE_ME_WITH_URL'", ("'{0}'" -f $session)
$txt = $txt -replace '"REPLACE_ME_WITH_URL"', ('"{0}"' -f $session)
$txt = $txt -replace 'pair_REPLACE_ME_WITH_URL', ("pair_{0}" -f $pairKey)
if($txt -ne $before){
  $bak = "$orch.bak_$(Get-Date -f yyyyMMdd-HHmmss)"
  Copy-Item $orch $bak -Force
  Write-Host "[20-Orch] Backup -> $bak"
  Set-Content -LiteralPath $orch -Value $txt -Encoding UTF8
  Write-Host "[20-Orch] Patched placeholders."
}else{
  Write-Host "[20-Orch] No placeholders found; nothing changed."
}
