param(
  [Parameter(Mandatory=$true)][string[]]$WrapFiles,
  [string]$StagingRepo = "$env:USERPROFILE\Documents\GitHub\CoCivium",
  [string]$OutRelDir = "docs\cowrap-intake",
  [string]$BranchPrefix = "cowrap/intake",
  [string]$BackchatTo = "Grand Migration — vNext",
  [switch]$EmitBackchat
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'

function _CoSafe([string]$s){ (CoSafeName $s) }

# Validate staging repo
if (-not (Test-Path (Join-Path $StagingRepo '.git'))) { throw "Staging repo is not a git repo: $StagingRepo" }

# Expand and verify wrap files
$WrapFiles = $WrapFiles | ForEach-Object { [IO.Path]::GetFullPath($_) } | Where-Object { Test-Path $_ }
if (-not $WrapFiles -or $WrapFiles.Count -lt 1) { throw "No valid CoWrap snapshot files resolved." }

$stampFile = CoTsFile
$intakeRel = Join-Path $OutRelDir ("intake_" + $stampFile)
$intakeDir = Join-Path $StagingRepo $intakeRel
$rawDir    = Join-Path $intakeDir 'raw'
$perRepo   = Join-Path $intakeDir 'per-repo'
[IO.Directory]::CreateDirectory($rawDir)  | Out-Null
[IO.Directory]::CreateDirectory($perRepo) | Out-Null

# Copy raw snapshots
foreach($w in $WrapFiles){
  $leaf = _CoSafe (Split-Path -Leaf $w)
  Copy-Item $w (Join-Path $rawDir $leaf) -Force
}

# Parse wraps into per-repo MDs and a summary
$summary = New-Object System.Text.StringBuilder
$null = $summary.AppendLine("# CoWrap Intake — $([DateTime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ'))")
$null = $summary.AppendLine()
$allRepos = @()

function Extract-Section([string[]]$lines, [string]$marker){
  $i = ($lines | Select-String -SimpleMatch $marker | Select-Object -First 1).LineNumber
  if(-not $i){ return "" }
  $i = $i - 1
  $j = ($lines | Select-String -Pattern '^\#\#\# ' | Where-Object { $_.LineNumber -gt $i } | Select-Object -First 1).LineNumber
  if($j){ $j = $j - 2 } else { $j = $lines.Length - 1 }
  return ($lines[$i+1 .. $j] -join [Environment]::NewLine).Trim()
}

foreach($w in $WrapFiles){
  $t = Get-Content $w -Raw
  $lines = $t -split "`r?`n"
  # repo blocks start with "## Repo: "
  $headers = Select-String -InputObject $t -Pattern '^## Repo:\s*(.+)$' -AllMatches
  if(-not $headers.Matches){ continue }
  for($k=0; $k -lt $headers.Matches.Count; $k++){
    $curIdx = $headers.Matches[$k].Index
    $nextIdx = if($k -lt $headers.Matches.Count-1){ $headers.Matches[$k+1].Index } else { $t.Length }
    $block = $t.Substring($curIdx, $nextIdx - $curIdx)
    $bLines = $block -split "`r?`n"

    $repoPath = ($bLines | Select-String -Pattern '^## Repo:\s*(.+)$' | Select-Object -First 1).Matches.Groups[1].Value.Trim()
    $nameLine = ($bLines | Select-String -Pattern '^Name:\s*(.+)$' | Select-Object -First 1)
    $branchLn = ($bLines | Select-String -Pattern '^Branch:\s*(.+)$' | Select-Object -First 1)
    $name  = if($nameLine){ $nameLine.Matches.Groups[1].Value.Trim() } else { Split-Path -Leaf $repoPath }
    $branch= if($branchLn){ $branchLn.Matches.Groups[1].Value.Trim() } else { "" }

    $status = Extract-Section $bLines '### Status'
    $recent = Extract-Section $bLines '### Recent Commits'

    $statusLines = @(); if($status){ $statusLines = $status -split "`r?`n" }
    $changedCount = ($statusLines | ?{ $_ -match '^\?\? |^ M |^A  |^D  ' }).Count

    $safeName = _CoSafe $name
    $outPath  = Join-Path $perRepo ($safeName + '__' + $stampFile + '.md')

    $content = @"
# $name — CoWrap Intake ($stampFile)
RepoPath: $repoPath
Branch: $branch

## Status
$status

## Recent Commits
$recent

## Inferred Next Actions (draft)
- Uncommitted changes detected: **$changedCount**
- If >0: create a branch and commit; push a PR.
- If branch is stale/ahead/behind: sync with remote.
"@
    [IO.File]::WriteAllText($outPath, $content, [Text.Encoding]::UTF8)

    $allRepos += [pscustomobject]@{ Name=$name; Branch=$branch; Changed=$changedCount; File=$outPath }
  }
}

# Write SUMMARY.md
$sumPath = Join-Path $intakeDir 'SUMMARY.md'
$null = $summary.AppendLine("## Repos extracted")
foreach($r in $allRepos){
  $null = $summary.AppendLine( ("- {0} (branch `{1}`, changes ~{2}) — {3}" -f $r.Name,$r.Branch,$r.Changed,(Resolve-Path $r.File)) )
}
[IO.File]::WriteAllText($sumPath, $summary.ToString(), [Text.Encoding]::UTF8)

# Commit on a new branch
Push-Location $StagingRepo
try{
  $branch = "$BranchPrefix-$stampFile"
  git switch -c $branch 2>$null; if($LASTEXITCODE -ne 0){ git switch $branch | Out-Null }
  git add $intakeRel
  git commit -m "cowrap intake: $($WrapFiles.Count) snapshot(s) staged at $intakeRel"
  if((git remote) -match '\S'){ git push -u origin $branch }
} finally { Pop-Location }

# Optional: emit a paste-ready summary via existing Backchat tool
$pastePath = $sumPath.Replace('.md','.paste.md')
$pasteBody = Get-Content $sumPath -Raw
$paste = @"
> CoWrap Intake: $($WrapFiles.Count) snapshot(s) staged at `$($intakeRel)`
---
$pasteBody
"@
[IO.File]::WriteAllText($pastePath, $paste, [Text.Encoding]::UTF8)

if($EmitBackchat){
  & "$env:USERPROFILE\Downloads\CoAgent_Bootstrap\scripts\CoBackchat.Emit.ps1" -To $BackchatTo -Type 'handoff' -From 'CoWrap Intake' -BodyFile $pastePath
}

Write-Host "Intake complete:"
Write-Host "  Summary: $sumPath"
Write-Host "  Branch : $branch"
Write-Host "  Paste  : $pastePath"
