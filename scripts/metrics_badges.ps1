param(
  [string]$Root = "$HOME\\Documents\\GitHub\\CoCache"
)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
$latestPath = Join-Path $Root "metrics\\latest.json"
$stalePath  = Join-Path $Root "metrics\\stale.json"
$thPath     = Join-Path $Root "metrics\\thresholds.json"
$brandDir   = Join-Path $Root "docs\\assets\\brand"

function Get-Badge([string]$level){
  switch($level){
    'crit' { return "assets/brand/cocivium_logo_red_tm.svg" }
    'warn' { return "assets/brand/cocivium_logo_amber_tm.svg" }
    'ok'   { return "assets/brand/cocivium_logo_green_tm.svg" }
    default{ return "assets/brand/cocivium_logo_gray_tm.svg" }
  }
}

$latest = if(Test-Path $latestPath){ Get-Content $latestPath -Raw | ConvertFrom-Json } else { $null }
$stale  = @()
if(Test-Path $stalePath){
  $raw = Get-Content $stalePath -Raw
  if(-not [string]::IsNullOrWhiteSpace($raw)){ $stale = $raw | ConvertFrom-Json }
}
$th = Get-Content $thPath -Raw | ConvertFrom-Json
$stWarn = [int]$th._stale_days.warn
$stCrit = [int]$th._stale_days.crit

# Build quick stale index
$staleIdx = @{}
foreach($s in $stale){ $staleIdx[$s.id] = $s }

$out = @{}

if($latest){
  foreach($prop in $latest.PSObject.Properties){
    $id = $prop.Name
    $row = $prop.Value

    # stale precedence
    if($staleIdx.ContainsKey($id)){
      $badge = Get-Badge 'crit'
      $out[$id] = $badge
      continue
    }
    # soft staleness by timestamp drift
    $level = 'ok'
    if($row.ts){
      $ts = [datetime]::Parse($row.ts).ToUniversalTime()
      $ageDays = ((Get-Date).ToUniversalTime() - $ts).TotalDays
      if($ageDays -ge $stCrit){ $level = 'crit' }
      elseif($ageDays -ge $stWarn){ $level = 'warn' }
    }

    if($th.PSObject.Properties.Name -contains $id){
      $rule = $th.$id
      $field = $rule.field
      $val = $null
      if($row.PSObject.Properties.Name -contains $field){ $val = $row.$field }
      if($val -ne $null -and $val -ne ''){
        [double]$dv = 0; [void][double]::TryParse("$val", [ref]$dv)
        switch($rule.kind){
          'lower_is_better' {
            if($dv -ge $rule.crit){ $level = 'crit' }
            elseif($dv -ge $rule.warn){ $level = 'warn' }
            else { if($level -eq 'ok') { $level = 'ok' } }
          }
          'zero_is_best' {
            if($dv -ge $rule.crit){ $level = 'crit' }
            elseif($dv -ge $rule.warn){ $level = 'warn' }
            else { if($level -eq 'ok') { $level = 'ok' } }
          }
        }
      }
    }

    $out[$id] = Get-Badge $level
  }
}

# also create a default for unknown metrics if needed later
$out | ConvertTo-Json -Depth 5



