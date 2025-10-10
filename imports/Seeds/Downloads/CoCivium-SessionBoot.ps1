Set-StrictMode -Version Latest; $ErrorActionPreference = "Stop"

param(
  [string]$RepoPath = "$HOME\Documents\GitHub\CoCivium",
  [string]$OutDirRelative = "admin/index",
  [switch]$Quiet
)

function Say($msg){ if(-not $Quiet){ Write-Host "== $msg" } }

function Write-IfChanged([string]$Path,[string]$Body){
  $lf = ($Body -replace "`r`n","`n" -replace "`r","`n").TrimEnd() + "`n"
  if(Test-Path $Path){
    $cur = Get-Content -Raw -LiteralPath $Path -Encoding utf8
    if($cur -eq $lf){ return $false }
  }
  $dir = Split-Path $Path
  if(-not (Test-Path $dir)){ New-Item -ItemType Directory -Force $dir | Out-Null }
  [IO.File]::WriteAllText($Path,$lf,[Text.UTF8Encoding]::new($false))
  return $true
}

function Get-GitHubSlug([string]$text){
  if([string]::IsNullOrWhiteSpace($text)){ return "" }
  $s = $text.ToLowerInvariant()
  $s = $s -replace '[^\p{L}\p{Nd}\s\-_]',''    # drop punctuation
  $s = $s -replace '\s+','-'                  # spaces -> dash
  $s = $s.Trim('-')
  return $s
}

# ---- Start ----
Set-Location $RepoPath
$repoRoot = (Get-Location).Path
$OutDir   = Join-Path $repoRoot $OutDirRelative

# Collect markdown files
$mdFiles = Get-ChildItem $repoRoot -Recurse -File | Where-Object {
  $_.Extension -match '^(?:\.md|\.mdx|\.markdown)$' -and
  ($_.FullName -notmatch '\\\.git\\') -and
  ($_.FullName -notmatch '\\node_modules\\') -and
  ($_.FullName -notmatch '\\dist\\|\\build\\|\\out\\')
}

# Pre-scan headings for anchor checks
$anchors = @{}  # path(rel) -> set of slugs
foreach($f in $mdFiles){
  $rel = ($f.FullName.Substring($repoRoot.Length+1)).Replace('\','/')
  $set = New-Object System.Collections.Generic.HashSet[string]
  foreach($line in (Get-Content -LiteralPath $f.FullName -Encoding utf8)){
    if($line -match '^\s*#+\s+(.+)$'){
      [void]$set.Add((Get-GitHubSlug $Matches[1]))
    }
  }
  $anchors[$rel] = $set
}

# Link graph
$edges = @()
$readmeTargets = @()
foreach($f in $mdFiles){
  $srcRel = ($f.FullName.Substring($repoRoot.Length+1)).Replace('\','/')
  $raw = Get-Content -Raw -LiteralPath $f.FullName -Encoding utf8

  # Markdown links (skip images)
  $matches = [regex]::Matches($raw,'(?<!\!)\[[^\]]+\]\((?<u>[^)\s]+)\)')
  foreach($m in $matches){
    $u = $m.Groups['u'].Value
    if($u -match '^(https?://|mailto:|#)'){ continue }

    $urlNoFrag = ($u -split '#')[0] -split '\?' | Select-Object -First 1
    $frag      = if($u -match '#(.+)$'){ $Matches[1] } else { $null }

    if([string]::IsNullOrWhiteSpace($urlNoFrag)){ continue }

    # Resolve to repo-relative
    $absTarget = $null
    if($urlNoFrag.StartsWith('/')){
      $absTarget = Join-Path $repoRoot ($urlNoFrag.TrimStart('/') -replace '/','\')
    } else {
      $absTarget = Join-Path (Split-Path $f.FullName) ($urlNoFrag -replace '/','\')
    }
    $exists = Test-Path -LiteralPath $absTarget
    $toRel  = if($exists){ ($absTarget.Substring($repoRoot.Length+1)).Replace('\','/') } else { ($urlNoFrag).Replace('\','/') }

    $anchorExists = $null
    if($frag -and $exists){
      $slug = Get-GitHubSlug $frag
      $set  = $anchors[$toRel]
      $anchorExists = ($set -and $set.Contains($slug))
    }

    $edges += [pscustomobject]@{
      from          = $srcRel
      to            = $toRel
      raw           = $u
      exists        = [bool]$exists
      anchor        = $frag
      anchorExists  = if($null -ne $anchorExists){ [bool]$anchorExists } else { $null }
    }

    if($srcRel -eq "README.md"){ $readmeTargets += $edges[-1] }
  }
}

# Backlinks map
$backlinks = @{}
foreach($e in $edges){
  $key = $e.to
  if(-not $backlinks.ContainsKey($key)){ $backlinks[$key] = New-Object System.Collections.Generic.HashSet[string] }
  [void]$backlinks[$key].Add($e.from)
}
$backlinksOut = @{}
$backlinks.Keys | Sort-Object | ForEach-Object {
  $backlinksOut[$_] = @($backlinks[$_] | Sort-Object)
}

# Sitemap (title + section headings)
$sitemap = @()
foreach($f in $mdFiles){
  $rel = ($f.FullName.Substring($repoRoot.Length+1)).Replace('\','/')
  $lines = Get-Content -LiteralPath $f.FullName -Encoding utf8
  $title = ($lines | Where-Object { $_ -match '^\s*#\s+(.+)$' } | Select-Object -First 1)
  if($title){ $title = ($title -replace '^\s*#\s+','').Trim() }
  $sections = @()
  foreach($ln in $lines){
    if($ln -match '^\s*##+\s+(.+)$'){ $sections += $Matches[1].Trim() }
  }
  $sitemap += [pscustomobject]@{ path=$rel; title=$title; sections=$sections }
}

# README targets summary
$missing = $readmeTargets | Where-Object { -not $_.exists }
$missingLines = if($missing){
  ($missing | Sort-Object to | ForEach-Object { "- ❌ `$_($._.raw)` from `$_($._.from)`" }) -join "`n"
} else { "_None_"}
$readmeReport = @"
# README targets check

**Missing files/paths referenced by README:**  
$missingLines

**Anchor issues:**  
$(
  ($readmeTargets | Where-Object { $_.exists -and $_.anchor -and ($_.anchorExists -eq $false) } |
    ForEach-Object { "- ⚠️ `"$($_.anchor)"` not found in `$($_.to)`" }) -join "`n"
  )
"@

# Write outputs
$changed = $false
$changed = (Write-IfChanged (Join-Path $OutDir 'link-graph.json')  ((@{ edges=$edges } | ConvertTo-Json -Depth 6))) -or $changed
$changed = (Write-IfChanged (Join-Path $OutDir 'backlinks.json')   (($backlinksOut | ConvertTo-Json -Depth 6)))      -or $changed
$changed = (Write-IfChanged (Join-Path $OutDir 'sitemap.json')     ((@{ files=$sitemap } | ConvertTo-Json -Depth 6))) -or $changed
$changed = (Write-IfChanged (Join-Path $OutDir 'README_targets.md') $readmeReport)                                    -or $changed

if($changed){ Say "Index updated under $OutDir" } else { Say "Index unchanged (already current)" }
