param([string]$Root)
function P([string]$s){ Write-Host $s -ForegroundColor Cyan }

function Get-Prop($o, [string]$name){
  if ($null -eq $o) { return $null }
  if ($o -is [hashtable]) { if ($o.ContainsKey($name)) { return $o[$name] } return $null }
  $p = $o.PSObject.Properties[$name]
  if ($p) { return $p.Value } return $null
}
function Coalesce([object[]]$vals){ foreach($v in $vals){ if($null -ne $v -and "$v" -ne ''){ return $v } } return $null }

$Inbox     = Join-Path $Root 'advice\inbox'
$Processed = Join-Path $Root 'docs\intent\advice\processed'
$Archive   = Join-Path $Root 'docs\intent\advice\archive'
$IdxJson   = Join-Path (Join-Path $Root 'docs\intent\advice\index') 'advice.index.json'

# 0) README
$inboxReadme = Join-Path $Inbox 'README.md'
if (Test-Path $inboxReadme) { P '✓ inbox/README.md present' } else { P '⚠ inbox/README.md: MISSING' }

# 1) Files (force arrays)
$inboxFiles     = @( if(Test-Path $Inbox){ Get-ChildItem -File $Inbox | Select-Object -Expand FullName } )
$processedFiles = @( if(Test-Path $Processed){ Get-ChildItem -File $Processed | Select-Object -Expand FullName } )
$archiveFiles   = @( if(Test-Path $Archive){ Get-ChildItem -File $Archive | Select-Object -Expand FullName } )

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
  $lp = Coalesce @((Get-Prop $x 'latestPath'), (Get-Prop $x 'out'), (Get-Prop $x 'path'))
  if ($lp) { return $lp }
  $hist = @(@(Get-Prop $x 'history'))
  if ($hist.Count -gt 0){
    $last = $hist |
      ForEach-Object {
        if ($_ -is [string]) { return $null }
        $hts  = Coalesce @($_.ts, $_.timestamp, $_.latestTs, $_.time)
        $hpat = Coalesce @($_.path, $_.latestPath, $_.out)
        [pscustomobject]@{ ts=$hts; path=$hpat }
      } |
      Where-Object { $_ -ne $null } |
      Sort-Object { $_.ts } |
      Select-Object -Last 1
    if ($last){ return $last.path }
  }
  return $null
}

# 3) Orphans (indexed but file missing)
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
foreach($f in
# 3) Orphans (indexed but file missing)
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

# 5) Size guardrail
$overs = @()
$index | ForEach-Object {
  $lp = Get-LatestPath $_
  if ($lp -and (Test-Path $lp)) {
    $kb = [math]::Round((Get-Item $lp).Length/1KB)
    if ($kb -gt 256) { $overs += ("{0} KB => {1}" -f $kb,$lp) }
  }
}
if ($overs.Count){ P '⚠ Oversized latest items:'; $overs | ForEach-Object { P "   - $_" } } else { P '✓ No oversized latest items' }
