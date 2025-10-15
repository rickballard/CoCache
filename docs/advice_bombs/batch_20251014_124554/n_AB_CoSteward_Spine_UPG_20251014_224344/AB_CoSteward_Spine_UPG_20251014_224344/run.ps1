# CoSteward Advice Bomb — DO block (non-destructive)
Param(
  [string]$TargetRoot = "$HOME\Documents\GitHub\CoCache",
  [switch]$DryRun
)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
function Write-Status($ok, $msg) {
  $outPath = Join-Path $PSScriptRoot "out.txt"
  $statusPath = Join-Path $PSScriptRoot "status.json"
  $stamp = Get-Date -Format "yyyy-MM-ddTHH:mm:sszzz"
  $out = "$stamp`t" + ($ok ? "OK" : "ERROR") + "`t$msg"
  $out | Out-File -FilePath $outPath -Encoding UTF8 -Append
  $obj = @{ ok = $ok; message = $msg; time = $stamp }
  $obj | ConvertTo-Json | Out-File -FilePath $statusPath -Encoding UTF8
  Write-Host $msg
}
try {
  if (!(Test-Path $TargetRoot)) { throw "TargetRoot not found: $TargetRoot" }
  $dest = Join-Path $TargetRoot "CoSteward"
  if (!(Test-Path $dest)) { if (-not $DryRun) { New-Item -ItemType Directory -Force -Path $dest | Out-Null } }
  $copyList = @("templates","scripts","sandbox","advice-bombs","heartbeats","governance",".github","streams.yml","README.md")
  foreach($item in $copyList) {
    $src = Join-Path $PSScriptRoot $item
    $dst = Join-Path $dest $item
    if (Test-Path $src) {
      if ($DryRun) { Write-Host "[DryRun] Would copy $src -> $dst" }
      else {
        if ((Get-Item $src).PSIsContainer) { robocopy $src $dst /E /NFL /NDL /NJH /NJS /NP | Out-Null }
        else { New-Item -ItemType Directory -Force -Path (Split-Path $dst) | Out-Null; Copy-Item $src $dst -Force }
      }
    }
  }
  Write-Status $true "CoSteward skeleton installed to $dest"
  Write-Status $true "Next: Run scripts/new_heartbeat.ps1 and review streams.yml"
  exit 0
} catch { Write-Status $false ("Failed: " + $_.Exception.Message); exit 1 }
