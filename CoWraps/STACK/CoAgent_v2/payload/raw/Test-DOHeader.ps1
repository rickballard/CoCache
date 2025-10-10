param([string]$Path)

function Test-DOHeader {
  [CmdletBinding()]
  param([Parameter(Mandatory)][string]$Path)

  if (-not (Test-Path -LiteralPath $Path)) { Write-Error ("File not found: {0}" -f $Path); return $false }
  $text = Get-Content -Raw -LiteralPath $Path

  # Find <# --- ... --- #>
  $m = [regex]::Match($text, '<#\s*---\s*(?<yaml>[\s\S]*?)\s*---\s*#>')
  if (-not $m.Success) { Write-Error 'Missing commented YAML header block `<# --- ... --- #>`.'; return $false }
  $yaml = $m.Groups['yaml'].Value

  function Get-Scalar([string]$k){
    $mm = [regex]::Match($yaml, "(?m)^\s*$k\s*:\s*(.+?)\s*$")
    if($mm.Success){ return $mm.Groups[1].Value.Trim().Trim('"', "'") } else { $null }
  }

  # repo.path (inline map)
  $repoPath = $null
  $repoM = [regex]::Match($yaml, "(?ms)^\s*repo\s*:\s*\{(?<obj>[^}]*)\}")
  if($repoM.Success){
    $pm = [regex]::Match($repoM.Groups['obj'].Value, 'path\s*:\s*("?)(?<p>[^",}]+)\1')
    if($pm.Success){ $repoPath = $pm.Groups['p'].Value }
  }

  # risk.* (inline map of booleans)
  $risk=@{}
  $riskM = [regex]::Match($yaml, "(?ms)^\s*risk\s*:\s*\{(?<obj>[^}]*)\}")
  if($riskM.Success){
    foreach($pair in ($riskM.Groups['obj'].Value -split ',')){
      if($pair -match '^\s*(\w+)\s*:\s*(true|false)\s*$'){ $risk[$matches[1]] = [bool]::Parse($matches[2]) }
    }
  }

  # consent.* (inline map of booleans)
  $consent=@{}
  $consM = [regex]::Match($yaml, "(?ms)^\s*consent\s*:\s*\{(?<obj>[^}]*)\}")
  if($consM.Success){
    foreach($pair in ($consM.Groups['obj'].Value -split ',')){
      if($pair -match '^\s*(\w+)\s*:\s*(true|false)\s*$'){ $consent[$matches[1]] = [bool]::Parse($matches[2]) }
    }
  }

  $ok = $true
  $title = Get-Scalar 'title'
  if(-not $title){ Write-Error 'Missing: title'; $ok = $false }
  if(-not $repoPath){ Write-Error 'Missing: repo.path inside {repo: { ... }}'; $ok = $false }
  foreach($k in 'writes','network','secrets','destructive'){
    if(-not $risk.ContainsKey($k)){ Write-Error ("Missing: risk.{0}" -f $k); $ok = $false }
  }

  if($consent.ContainsKey('allow_writes') -and $consent['allow_writes']){
    Write-Warning 'consent.allow_writes=true — overrides default deny.'
  }
  if($consent.ContainsKey('allow_network') -and $consent['allow_network']){
    Write-Warning 'consent.allow_network=true — overrides default deny.'
  }

  # Body marker
  $body = $text.Substring($m.Index + $m.Length)
  $hasMarker = $body -match '(?m)^\s*#\s*\[PASTE IN POWERSHELL\]\s*$'
  if(-not $hasMarker){ Write-Warning "Body missing '# [PASTE IN POWERSHELL]' marker." }

  [pscustomobject]@{
    file=$Path; title=$title; repoPath=$repoPath
    risk=$risk; consent=$consent; hasPasteMarker=$hasMarker
  } | ConvertTo-Json -Depth 5 | Write-Output

  return $ok
}

if ($PSBoundParameters.ContainsKey('Path')) {
  if (Test-DOHeader -Path $Path) { Write-Host 'PASS' -ForegroundColor Green } else { Write-Error 'FAIL' }
}
