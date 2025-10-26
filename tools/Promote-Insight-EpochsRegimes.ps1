param([string]$BatchTS = "20251014_124554")
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest

$batchRoot = "docs/advice_bombs/batch_$BatchTS"
if(!(Test-Path $batchRoot)){ throw "Batch folder not found: $batchRoot" }

$oRoot = Get-ChildItem $batchRoot -Directory -Filter 'o_CoSuite_Insights_EpochsRegimes_*' | Select-Object -First 1
if(-not $oRoot){ throw "No o_* insights folder found under $batchRoot" }

$mirrorZip = Join-Path $batchRoot ($oRoot.BaseName + '.zip')
if(!(Test-Path $mirrorZip)){ throw "Mirror ZIP not found: $mirrorZip" }

$payloadDir = Get-ChildItem $oRoot.FullName -Directory -Filter 'insights_*' | Select-Object -First 1
if(-not $payloadDir){ throw "No insights_* folder found under $($oRoot.FullName)" }

$innerTS = ($payloadDir.Name -replace '^\D+_', '')
$dst = "docs/CoSuite/CoCivium/insights/epochs-regimes/$innerTS"
$br  = "feat/insights-epochs-regimes-$innerTS"

git switch -c $br 2>$null | Out-Null

New-Item -ItemType Directory -Force -Path $dst | Out-Null
Copy-Item -Recurse -Force "$($payloadDir.FullName)\*" $dst\

$sha = (Get-FileHash -Algorithm SHA256 -LiteralPath $mirrorZip).Hash
@"
# Epochs & Regimes insight ($innerTS)

**Provenance**
- Batch: \`$BatchTS\`
- Mirror ZIP: \`$mirrorZip\`
- SHA256: \`$sha\`

Promoted from advice-bombs ingestion and organized for CoCivium insights.
"@ | Set-Content -Path (Join-Path $dst 'INDEX.md') -Encoding UTF8

git add $dst
$changes = git diff --cached --name-only
if([string]::IsNullOrWhiteSpace($changes)){
  Write-Host "No changes to commit; skipping push/PR."
  exit 0
}

git commit -m "feat(CoCivium): add Epochs/Regimes insight ($innerTS) with provenance" --no-verify
git push -u origin $br

gh pr create --base main --head $br `
  --title "feat(CoCivium): Epochs/Regimes insight ($innerTS)" `
  --body  "Promote Epochs/Regimes insight from batch $BatchTS into CoCivium with provenance from $($oRoot.BaseName)." `
  --label "area:advice" --label "needs:triage"

