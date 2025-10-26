param([string]$Root)
function V([string]$s){ Write-Host $s -ForegroundColor Magenta }

function Get-Prop($o, [string]$name){
  if ($null -eq $o) { return $null }
  if ($o -is [hashtable]) { if ($o.ContainsKey($name)) { return $o[$name] } return $null }
  $p = $o.PSObject.Properties[$name]
  if ($p) { return $p.Value } return $null
}
function Coalesce([object[]]$vals){ foreach($v in $vals){ if($null -ne $v -and "$v" -ne ''){ return $v } } return $null }

$AdviceIdx = Join-Path (Join-Path $Root 'docs\intent\advice\index') 'advice.index.json'
if (!(Test-Path $AdviceIdx)) { V 'Advice: (none indexed yet)'; exit 0 }

$raw = @(Get-Content $AdviceIdx -Raw | ConvertFrom-Json)

# Normalize
$norm = foreach($x in $raw){
  $latestTs   = Coalesce @(
    (Get-Prop $x 'latestTs'),
    (Get-Prop $x 'latest'),
    (Get-Prop $x 'timestamp')
  )
  $latestPath = Coalesce @(
    (Get-Prop $x 'latestPath'),
    (Get-Prop $x 'out'),
    (Get-Prop $x 'path')
  )
  if (-not $latestTs -or -not $latestPath){
    $hist = @(@(Get-Prop $x 'history'))
    if ($hist.Count -gt 0){
      # Normalize history entries that might be objects with different keys
      $last = $hist |
        ForEach-Object {
          if ($_ -is [string]) { return $null } # skip bare strings
          $hts  = Coalesce @($_.ts, $_.timestamp, $_.latestTs, $_.time)
          $hpat = Coalesce @($_.path, $_.latestPath, $_.out)
          [pscustomobject]@{ ts=$hts; path=$hpat }
        } |
        Where-Object { $_ -ne $null } |
        Sort-Object { $_.ts } |
        Select-Object -Last 1
      if ($last){
        if (-not $latestTs)   { $latestTs   = $last.ts }
        if (-not $latestPath) { $latestPath = $last.path }
      }
    }
  }
  [pscustomobject]@{
    family     = Coalesce @((Get-Prop $x 'family'), (Get-Prop $x 'title'))
    title      = Get-Prop $x 'title'
    ext        = Get-Prop $x 'ext'
    latestTs   = $latestTs
    latestPath = $latestPath
  }
}

$AdvN = ($norm | Measure-Object).Count
V ("Advice families: {0}; latest:" -f $AdvN)

$norm |
  Where-Object { $_.latestTs } |
  Sort-Object { $_.latestTs } -Descending |
  Select-Object -First 5 |
  ForEach-Object { V ("  - {0} — {1}" -f $_.latestTs, $_.latestPath) }

$overs = @()
$norm | ForEach-Object {
  if ($_.latestPath -and (Test-Path $_.latestPath)) {
    $kb = [math]::Round((Get-Item $_.latestPath).Length/1KB)
    if ($kb -gt 256) { $overs += ("{0} ({1} KB)" -f ($_.family ?? '(unknown)'),$kb) }
  }
}
if ($overs.Count) { V ("  ⚠ Oversized: {0}" -f ($overs -join ', ')) }
