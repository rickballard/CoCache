Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$script:CoRoot  = Join-Path $HOME 'Downloads\CoTemp'
$script:PanelDB = Join-Path $script:CoRoot 'panels'
$null = New-Item -ItemType Directory -Force -Path $script:PanelDB | Out-Null
function Get-CoPanels {
  try {
    $files = Get-ChildItem -LiteralPath $script:PanelDB -Filter '*.json' -File -ErrorAction SilentlyContinue
    $list = @(); foreach($f in $files){ try { $list += (Get-Content -Raw -LiteralPath $f.FullName | ConvertFrom-Json) } catch {} }
    return @($list | Sort-Object -Property name)
  } catch { return @() }
}
function Register-CoPanel { [CmdletBinding()] param([string]$Name,[string]$SessionId,[switch]$Share)
  if (-not $SessionId) { if ($env:COSESSION_ID) { $SessionId = $env:COSESSION_ID } else { $SessionId = "co-$PID-$(Get-Date -Format 'yyyyMMdd-HHmmss')" } }
  $env:COSESSION_ID = $SessionId
  if (-not $Name) {
    if ($Share) { $Name = 'SharePanel' } else {
      $existing = @(Get-CoPanels | Where-Object { $_.name -like 'Panel-*' } | ForEach-Object { ($_.'name' -replace '^\D+','') } | Where-Object { $_ -match '^\d+$' } | ForEach-Object { [int]$_ })
      $n = if ($existing.Count -gt 0) { ([array]($existing | Measure-Object -Maximum).Maximum + 1) } else { 1 }
      $Name = "Panel-$n"
    }
  }
  $sessionRoot = Join-Path $script:CoRoot ("sessions\{0}" -f $SessionId)
  $inbox=Join-Path $sessionRoot 'inbox'; $outbox=Join-Path $sessionRoot 'outbox'; $logs=Join-Path $sessionRoot 'logs'
  $null = New-Item -ItemType Directory -Force -Path $sessionRoot,$inbox,$outbox,$logs | Out-Null
  try { [Console]::Title = "PS [$SessionId] $Name" } catch {}
  $rec=[pscustomobject]@{ pid=$PID; name=$Name; session_id=$SessionId; inbox=$inbox; outbox=$outbox; logs=$logs; ts=(Get-Date).ToString('o') }
  $jsonPath = Join-Path $script:PanelDB ("{0}.json" -f $PID)
  $rec | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $jsonPath -Encoding UTF8
  Write-Host ("Registered panel '{0}' for session '{1}'" -f $Name, $SessionId) -ForegroundColor Cyan
  return $rec
}
function Resolve-CoTarget { [CmdletBinding()] param([Parameter(Mandatory)][string]$To)
  $db=@(Get-CoPanels); $hit=@($db | Where-Object { $_.name -ieq $To -or $_.session_id -ieq $To })
  if ($hit.Count -eq 0) { throw "Target not found: $To. (Try: Get-CoPanels)" }
  return $hit[0]
}
function Drop-CoText { [CmdletBinding()] param([Parameter(Mandatory)][string]$To,[Parameter(Mandatory)][string]$Name,[Parameter(Mandatory)][string]$Text)
  $t=Resolve-CoTarget -To $To; $dest=Join-Path $t.inbox $Name
  Set-Content -LiteralPath $dest -Value $Text -Encoding UTF8
  Write-Host ("Dropped -> {0}" -f $dest) -ForegroundColor Green
  return $dest
}
function Drop-CoDO { [CmdletBinding()] param([Parameter(Mandatory)][string]$To,[string]$Title="DO-from-$env:COMPUTERNAME",[string]$RepoPath=(Join-Path $HOME 'Desktop\CoAgent_SandboxRepo'),[string]$Brief="Ad-hoc DO",[switch]$AllowWrites,[switch]$AllowNetwork,[Parameter(Mandatory)][string]$Body)
  $t=Resolve-CoTarget -To $To
  $name = "DO_{0}_{1}.ps1" -f ($Title -replace '[^\w\-]','_'), (Get-Date -Format 'HHmmss')
  $path = Join-Path $t.inbox $name
  $aw=$AllowWrites.IsPresent.ToString().ToLower(); $an=$AllowNetwork.IsPresent.ToString().ToLower()
  $header=@"
<# ---
title: "$Title"
session_id: "$($t.session_id)"
repo: { name: "Sandbox", path: "$RepoPath" }
risk: { writes: $aw, network: $an, secrets: false, destructive: false }
brief: "$Brief"
consent: { allow_writes: $aw, allow_network: $an }
--- #>
# [PASTE IN POWERSHELL]
"@
  Set-Content -LiteralPath $path -Value ($header + "`r`n" + $Body) -Encoding UTF8
  Write-Host ("Queued DO -> {0}" -f $path) -ForegroundColor Green
  return $path
}
