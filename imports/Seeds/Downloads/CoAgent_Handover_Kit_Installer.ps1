<#
.SYNOPSIS
  Seed CoAgent "Handover Advice Bomb" + Ops scripts into a local repo and (optionally) push a PR.

.PARAMETER Repo
  Local path to the CoAgent git repo. Defaults to C:\Users\<you>\Documents\GitHub\CoAgent

.PARAMETER Branch
  Feature branch name to create. Default: chore/handover-advice-<timestamp>

.PARAMETER OpenPR
  If set and GitHub CLI (gh) is installed+authed, opens a PR to main and enables auto-merge (squash).

.EXAMPLE
  pwsh -File .\CoAgent_Handover_Kit_Installer.ps1 -Repo "C:\Users\Chris\Documents\GitHub\CoAgent" -OpenPR
#>

param(
  [string]$Repo   = (Join-Path $env:USERPROFILE 'Documents\GitHub\CoAgent'),
  [string]$Branch = ("chore/handover-advice-{0}" -f (Get-Date -Format 'yyyyMMdd_HHmmss')),
  [switch]$OpenPR
)

function Die([string]$Msg){ Write-Host $Msg -ForegroundColor Red; exit 1 }

if (-not (Test-Path $Repo)) { Die "Repo path not found: $Repo" }

Push-Location $Repo
try {
  git rev-parse --is-inside-work-tree *> $null 2>&1
  if ($LASTEXITCODE -ne 0) { Die "Not a git repo: $Repo" }

  # --- Create folders ---
  $docsDir = Join-Path $Repo 'docs\handover'
  $opsDir  = Join-Path $Repo 'ops'
  New-Item -ItemType Directory -Force -Path $docsDir,$opsDir | Out-Null

  # --- Write Advice Bomb ---
  $advicePath = Join-Path $docsDir 'Handover_AdviceBomb.md'
  @'
# CoAgent Session Handover & CoWrap — Advice Bomb

**Why:** Sessions roll frequently (8–16h) for memory hygiene, anomalies, or milestone snapshots. This standard ensures we end, verify, and hand over cleanly.

## 1) Handover Triggers
- Timer-based hygiene (8–16h) • Behavior anomalies • Milestone snapshot • Ownership shift.

## 2) Termination Checklist (CoWrap)
- **Capture**: brief intent, pivots, decisions, assumptions, risks, dependencies.
- **Transcript** → `transcripts/session.md` (clean; no PII; include pivotal quotes if needed).
- **Payload** → `payload/` (md/ps1/json/png/svg/etc).
- **Notes** → `notes/`
  - `INTENTIONS.md` (mark unfinished with `(Unfinished)`), `ASSUMPTIONS.md`, `DECISIONS.md`,
    `DEPENDENCIES.md`, `RISKS.md`, `GLOSSARY.md`, `WEBSITE_MANIFEST.md`, `DEPRECATED.md`.
- **Summaries** → `summaries/` (`TLDR.md`, `ROADMAP_NOTES.md`, `SOURCES.md`).
- **Envelope** → `_spanky/`
  - `_copayload.meta.json`, `_wrap.manifest.json`, `checksums.json`,
  - `out.txt` first line: `[STATUS] items=<sum> transcripts=<#> payload=<#> notes=<#> summaries=<#>`.

## 3) Spanky ZIP Layout
```
Spanky_<ShortName>_<YYYYMMDD_HHMMSS>.zip
  /_spanky/ _copayload.meta.json, _wrap.manifest.json, out.txt, checksums.json
  /transcripts/ session.md
  /payload/    (all deliverables)
  /notes/      BPOE.md, INTENTIONS.md, DEPENDENCIES.md, DECISIONS.md, ASSUMPTIONS.md,
               RISKS.md, GLOSSARY.md, WEBSITE_MANIFEST.md, DEPRECATED.md
  /summaries/  TLDR.md, ROADMAP_NOTES.md, SOURCES.md
```

## 4) Verification Rules (structural)
- Required entries present (see §3).
- `out.txt` counts match actual contents (items = transcripts + payload + notes + summaries).
- No `MISSING_*` stubs unless justified in `INTENTIONS.md (Unfinished)` with next-steps.
- Optional: `checksums.json` matches current bytes.

## 5) Qualitative QA (session-owned)
- **Intent completeness** (scope, audience, interfaces).
- **Traceability** (links/IDs to repos, issues, prior sessions).
- **Coherence** (dedupe contradictions into `DEPRECATED.md` with pointers).
- **Dual-face readiness** (AI facts vs human narrative/visuals).
- **Exit criteria** met; regenerate zip if needed and re-verify.

## 6) Global Sweep (multi-session)
- Run `ops/Spanky-GlobalVerify.ps1` to scan `Downloads` and emit rework CSV + “Spanky ready:” lines.
- Run `ops/Spanky-BuildQAPacks.ps1` to assemble non-destructive QA packs with per-session CoPings.

## 7) Failure Modes & Fixes
- Bad/missing `_spanky/out.txt` → fix counts to reflect actual content.
- Transcript-only drops → declare gaps `(Unfinished)` in `INTENTIONS.md`, add notes/summaries, regen.
- Hidden dot-prefixed zips not found → verifier already includes dot-prefixed patterns (`.51_…`).

## 8) Governance
- Source-of-truth chain: repo → AI-face site → human-face site (document exceptions).
- Each handover: machine-verifiable Spanky zip + human-usable TLDR.
- Never overwrite prior deliverables; version with timestamps.
'@ | Set-Content -Encoding UTF8 -LiteralPath $advicePath

  # --- Write Global Verify script ---
  $verifyPath = Join-Path $opsDir 'Spanky-GlobalVerify.ps1'
  @'
param(
  [string]$Downloads = (Join-Path $env:USERPROFILE "Downloads")
)
if (-not (Test-Path $Downloads)) { Write-Host "Downloads not found: $Downloads" -ForegroundColor Red; exit 1 }

$BaseRegex = "^(?:\.(\d+[a-z]?)[-_])?Spanky_.*\.zip$"
Add-Type -AssemblyName System.IO.Compression.FileSystem | Out-Null
function Open-Zip([string]$z){ $fs=[IO.File]::OpenRead($z); $zip=[IO.Compression.ZipArchive]::new($fs,[IO.Compression.ZipArchiveMode]::Read,$false); ,$fs,$zip }
function Entries($zip){ foreach($e in $zip.Entries){ ($e.FullName -replace '\\','/').TrimStart('/') } }
function FirstLine($zip,$entry){ $e=$zip.GetEntry($entry); if(-not $e){return $null}; $sr=[IO.StreamReader]::new($e.Open()); try{ $l=$sr.ReadLine(); if($l){$l.Trim()}} finally{$sr.Dispose()} }
function Count-P($present,$pref){ @($present | ?{ $_ -like "$pref*" -and -not $_.EndsWith('/') }).Count }

$zips = Get-ChildItem -LiteralPath $Downloads -File -Force -Filter "*.zip" | ?{ $_.Name -match $BaseRegex } | sort LastWriteTime -desc
if (-not $zips) { Write-Host "No Spanky zips found in $Downloads" -ForegroundColor Yellow; exit 0 }

$Required = @("_spanky/_copayload.meta.json","_spanky/_wrap.manifest.json","_spanky/checksums.json","_spanky/out.txt","transcripts/session.md")
$rows=@()
foreach($zf in $zips){
  try{
    $fs,$zip = Open-Zip $zf.FullName
    try{
      $present = @(Entries $zip)
      $missing = @(); foreach($r in $Required){ if(-not ($present -contains $r)){ $missing += $r } }
      $t=Count-P $present "transcripts/"; $p=Count-P $present "payload/"; $n=Count-P $present "notes/"; $s=Count-P $present "summaries/"
      $status=FirstLine $zip "_spanky/out.txt"
      $mm=$null
      if($status -and $status -match '\[STATUS\]\s+items=(\d+)\s+transcripts=(\d+)\s+payload=(\d+)\s+notes=(\d+)\s+summaries=(\d+)'){
        $stT=[int]$Matches[2]; $stP=[int]$Matches[3]; $stN=[int]$Matches[4]; $stS=[int]$Matches[5]
        if(($stT -ne ($t+$p+$n+$s)) -or ($stP -ne $p) -or ($stN -ne $n) -or ($stS -ne $s)){ $mm="counts" }
      }
      $verdict = if($missing.Count -eq 0){ if($mm){"OK*"} else {"OK"} } else {"MISSING"}
      $rows += [pscustomobject]@{
        FileName=$zf.Name; FullPath=$zf.FullName; Modified=$zf.LastWriteTime
        Verdict=$verdict; OutTxtStatus=$status; Transcripts=$t; Payload=$p; Notes=$n; Summaries=$s
      }
    } finally { $zip.Dispose(); $fs.Dispose() }
  } catch {
    $rows += [pscustomobject]@{ FileName=$zf.Name; FullPath=$zf.FullName; Modified=$zf.LastWriteTime; Verdict="ERROR" }
  }
}
$rows | Sort-Object Modified -Descending | Format-Table -AutoSize FileName,Verdict,Transcripts,Payload,Notes,Summaries,OutTxtStatus,Modified
$ok = $rows | ?{ $_.Verdict -like "OK*" -or $_.Verdict -eq "OK" }
foreach($r in $ok){
  $counts = if ($r.OutTxtStatus) { $r.OutTxtStatus } else { "[STATUS] items=? transcripts=$($r.Transcripts) payload=$($r.Payload) notes=$($r.Notes) summaries=$($r.Summaries)" }
  Write-Host "Spanky ready: $($r.FileName) ($counts)" -ForegroundColor Green
}
'@ | Set-Content -Encoding UTF8 -LiteralPath $verifyPath

  # --- Write Build QA Packs script ---
  $qaPath = Join-Path $opsDir 'Spanky-BuildQAPacks.ps1'
  @'
param(
  [string]$Downloads = (Join-Path $env:USERPROFILE "Downloads")
)
if (-not (Test-Path $Downloads)) { Write-Host "Downloads not found: $Downloads" -ForegroundColor Red; exit 1 }
$stamp = (Get-Date).ToString("yyyyMMdd_HHmmss")
$root  = Join-Path $Downloads ("Spanky_QA_Packs_{0}" -f $stamp)
New-Item -ItemType Directory -Force -Path $root | Out-Null

$BaseRegex = "^(?:\.(\d+[a-z]?)[-_])?Spanky_.*\.zip$"
Add-Type -AssemblyName System.IO.Compression.FileSystem | Out-Null
function Open-Zip([string]$z){ $fs=[IO.File]::OpenRead($z); $zip=[IO.Compression.ZipArchive]::new($fs,[IO.Compression.ZipArchiveMode]::Read,$false); ,$fs,$zip }
function Entries($zip){ foreach($e in $zip.Entries){ ($e.FullName -replace '\\','/').TrimStart('/') } }
function FirstLine($zip,$entry){ $e=$zip.GetEntry($entry); if(-not $e){return $null}; $sr=[IO.StreamReader]::new($e.Open()); try{ $l=$sr.ReadLine(); if($l){$l.Trim()}} finally{$sr.Dispose()} }
function Count-P($present,$pref){ @($present | ?{ $_ -like "$pref*" -and -not $_.EndsWith('/') }).Count }

$Required = @("_spanky/_copayload.meta.json","_spanky/_wrap.manifest.json","_spanky/checksums.json","_spanky/out.txt","transcripts/session.md")
$zips = Get-ChildItem -LiteralPath $Downloads -File -Force -Filter "*.zip" | ?{ $_.Name -match $BaseRegex } | sort LastWriteTime -desc

$bad=@()
foreach($zf in $zips){
  try{
    $fs,$zip = Open-Zip $zf.FullName
    try{
      $present = @(Entries $zip)
      $missing = @(); foreach($r in $Required){ if(-not ($present -contains $r)){ $missing += $r } }
      $t=Count-P $present "transcripts/"; $p=Count-P $present "payload/"; $n=Count-P $present "notes/"; $s=Count-P $present "summaries/"
      $status=FirstLine $zip "_spanky/out.txt"
      $mm=$null
      if($status -and $status -match '\[STATUS\]\s+items=(\d+)\s+transcripts=(\d+)\s+payload=(\d+)\s+notes=(\d+)\s+summaries=(\d+)'){
        $stT=[int]$Matches[2]; $stP=[int]$Matches[3]; $stN=[int]$Matches[4]; $stS=[int]$Matches[5]
        if(($stT -ne ($t+$p+$n+$s)) -or ($stP -ne $p) -or ($stN -ne $n) -or ($stS -ne $s)){ $mm="counts" }
      }
      $verdict = if($missing.Count -eq 0){ if($mm){"OK*"} else {"OK"} } else {"MISSING"}
      if($verdict -ne "OK"){ $bad += [pscustomobject]@{ FileName=$zf.Name; FullPath=$zf.FullName } }
    } finally { $zip.Dispose(); $fs.Dispose() }
  } catch {
    $bad += [pscustomobject]@{ FileName=$zf.Name; FullPath=$zf.FullName }
  }
}

if (-not $bad -or $bad.Count -eq 0) { Write-Host "All Spanky zips appear OK. No QA packs needed." -ForegroundColor Green; exit 0 }

foreach($b in $bad){
  $name = $b.FileName
  $key  = ($name -replace "^(?:\.(\d+[a-z]?)[-_])?Spanky_","") -replace "_\d{8}_\d{6}\.zip$",""
  $key  = ($key -split "_")[0]
  $pack = Join-Path $root ($name -replace "\.zip$","")
  New-Item -ItemType Directory -Force -Path $pack | Out-Null

  Copy-Item -LiteralPath $b.FullPath -Destination (Join-Path $pack $name) -Force

@"
# DO: Self-verify & repair deliverable (READ-ONLY first, then rebuild)
`$SessionKey = '$key'
`$Basic = Join-Path `$env:USERPROFILE 'Downloads\Verify-SpankyDeliverables.ps1'   # optional
`$Deep  = Join-Path `$env:USERPROFILE 'Downloads\Verify-SpankyDeliverables-Plus.ps1' # optional

# Preferred (repo version):
`$RepoOps = 'C:\Users\Chris\Documents\GitHub\CoAgent\ops'
if (Test-Path (Join-Path `$RepoOps 'Spanky-GlobalVerify.ps1')) { & (Join-Path `$RepoOps 'Spanky-GlobalVerify.ps1') }

# If MISSING/ERROR or counts mismatch persists:
#  1) Rebuild your Spanky_$key_<timestamp>.zip with required layout.
#  2) Ensure _spanky/out.txt first line matches actual counts.
#  3) Re-run verify and post the 'Spanky ready: ...' line.
"@ | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $pack 'CoPing.ps1')

@"
# QA PROMPT — $key (Self-Assessment by Session)

## 0) Structure
- Required files present? out.txt counts correct?

## 1) Intent completeness
- Scope, audience, interfaces; mark gaps in INTENTIONS.md (Unfinished).

## 2) Traceability
- Link repos/issues/prior sessions in SOURCES.md.

## 3) Coherence
- Dedupe contradictions into DEPRECATED.md with pointers; keep GLOSSARY terms consistent.

## 4) Dual-face readiness
- AI-face facts & permalinks; human-face narrative/diagrams. Update WEBSITE_MANIFEST.md.

## 5) Exit
- Regenerate zip only when counts correct, no unresolved MISSING_* (or justified), and verifier prints “Spanky ready:”.
"@ | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $pack 'QA_PROMPT.md')
}

Write-Host "QA packs ready: $root" -ForegroundColor Green
'@ | Set-Content -Encoding UTF8 -LiteralPath $qaPath

  # --- Git branch + commit + (optional) PR ---
  git fetch --all --prune | Out-Null
  git switch -c $Branch 2>$null; if ($LASTEXITCODE -ne 0) { git switch $Branch | Out-Null }

  git add $advicePath $verifyPath $qaPath
  git commit -m "docs(ops): add CoAgent handover Advice Bomb + Spanky Global Verify & QA pack scripts" 2>$null
  if ($LASTEXITCODE -ne 0) {
    Write-Host "NOTE: No content changes to commit (files identical). Creating a marker." -ForegroundColor Yellow
    $marker = Join-Path $docsDir ("KIT_APPLIED_{0}.md" -f (Get-Date -Format 'yyyyMMdd_HHmmss'))
    "Kit applied/verified at $(Get-Date -Format s)" | Set-Content -Encoding UTF8 -LiteralPath $marker
    git add $marker
    git commit -m "chore: add kit marker (no-op diff)"
  }

  git push -u origin $Branch
  Write-Host ("Pushed branch: {0}" -f $Branch) -ForegroundColor Cyan

  if ($OpenPR) {
    if (Get-Command gh -ErrorAction SilentlyContinue) {
      $pr = gh pr create --fill --base main --head $Branch
      Write-Host "PR opened: $pr" -ForegroundColor Cyan
      gh pr merge --squash --auto $Branch 2>$null
    } else {
      Write-Host "gh CLI not found. Open PR from $Branch → main on GitHub." -ForegroundColor Yellow
    }
  } else {
    Write-Host "Open a PR from $Branch → main on GitHub (or re-run with -OpenPR)." -ForegroundColor Yellow
  }
}
finally {
  Pop-Location
}
