param([string]$Root)
function P([string]$s){ Write-Host $s -ForegroundColor Cyan }

function Get-Prop($o, [string]$name){
  if ($null -eq $o) { return $null }
  if ($o -is [hashtable]) { if ($o.ContainsKey($name)) { return $o[$name] } else { return $null } }
  $p = $o.PSObject.Properties[$name]
  if ($p) { return $p.Value } else { return $null }
}

$Inbox     = Join-Path $Root 'advice\inbox'
$Processed = Join-Path $Root 'docs\intent\advice\processed'
$Archive   = Join-Path $Root 'docs\intent\advice\archive'
$IdxJson   = Join-Path (Join-Path $Root 'docs\intent\advice\index') 'advice.index.json'

# 0) Sanity: inbox README
$inboxReadme = Join-Path $Inbox 'README.md'
if (Test-Path $inboxReadme) { P '✓ inbox/README.md present' } else { P '⚠ inbox/README.md: MISSING' }

# 1) Files
$inboxFiles     = if(Test-Path $Inbox){ Get-ChildItem -File $Inbox | Select-Object -Expand FullName } else { @() }
$processedFiles = if(Test-Path $Processed){ Get-ChildItem -File $Processed | Select-Object -Expand FullName } else { @() }
$archiveFiles   = if(Test-Path $Archive){ Get-ChildItem -File $Archive | Select-Object -Expand FullName } else { @() }

P ("Inbox files: {0}" -f $inboxFiles.Count)
P ("Processed files: {0}" -f $processedFiles.Count)
P ("Archive files: {0}" -f $archiveFiles.Count)

# 2) Index
$index = @()
if (Test-Path $IdxJson) {
  try {
    $index = @((Get-Content $IdxJson -Raw | ConvertFrom-Json))
    P ("Index entries: {0}" -f $index.Count)
  } catch { P "⚠ Failed to parse advice.index.json: $($_.Exception.Message)" }
} else {
  P '⚠ advice.index.json: MISSING'
}

function Get-LatestPath($x){
  $lp = Get-Prop $x 'latestPath'
  if (-not $lp) { $lp = Get-Prop $x 'out' }
  if (-not $lp) {
    $hist = @(@(Get-Prop $x 'history'))
    if ($hist.Count -gt 0) {
      $last = $hist | Sort-Object { $_.ts } | Select-Object -Last 1
      $lp = $last.path
    }
  }
  return $lp
}

# 3) Orphans (indexed latestPath missing)
$orphans = @()
foreach($x in $index){
  $lp = Get-LatestPath $x
  if ($lp -and -not (Test-Path $lp)) { $orphans += $lp }
}
if ($orphans.Count){ P '⚠ Orphans (indexed, file missing):'; $orphans | ForEach-Object { P "   - $_" } } else { P '✓ No orphans' }

# 4) Inbox files not referenced by index
$indexedPaths = @()
$index | ForEach-Object {
  $lp = Get-LatestPath $_
  if ($lp) {
    $rp = (Resolve-Path -LiteralPath $lp -ErrorAction SilentlyContinue).Path
    if ($rp) { $indexedPaths += $rp }
  }
}
$notIndexed = @()
foreach($f in $inboxFiles){
  $rp = (Resolve-Path -LiteralPath $f -ErrorAction SilentlyContinue).Path
  if ($rp -and ($indexedPaths -notcontains $rp)) { $notIndexed += $f }
}
if ($notIndexed.Count){ P '⚠ Inbox files not in index:'; $notIndexed | ForEach-Object { P "   - $_" } } else { P '✓ All inbox files referenced (or inbox empty)' }

# 5) Size guardrail (256 KB)
$overs = @()
$index | ForEach-Object {
  $lp = Get-LatestPath $_
  if ($lp -and (Test-Path $lp)) {
    $kb = [math]::Round((Get-Item $lp).Length/1KB)
    if ($kb -gt 256) { $overs += ("{0} ({1} KB) => {2}" -f (Get-Prop $_ 'family'),$kb,$lp) }
  }
}
if ($overs.Count){ P '⚠ Oversized latest items:'; $overs | ForEach-Object { P "   - $_" } } else { P '✓ No oversized latest items' }

