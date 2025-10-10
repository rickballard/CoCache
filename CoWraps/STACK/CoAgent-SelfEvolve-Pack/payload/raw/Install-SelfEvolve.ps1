[CmdletBinding()]
param([string]$RepoPath="$HOME\Documents\GitHub\CoAgent",[switch]$OpenPR)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
function Info($m){ Write-Host "[INFO] $m" }
function Die($m){ throw "[FATAL] $m" }
$src = Split-Path -Parent $MyInvocation.MyCommand.Path
$root= Split-Path -Parent $src
$repo= Resolve-Path $RepoPath -ErrorAction SilentlyContinue
if (-not $repo) { Die "Repo not found: $RepoPath" }
if (-not (Test-Path (Join-Path $repo '.git'))) { Die "Not a git repo: $repo" }
$map = @{
  ".github\workflows\self-evolve.yml" = ".github\workflows\self-evolve.yml";
  "tools\self-evolve\SelfEvolve.ps1" = "tools\self-evolve\SelfEvolve.ps1";
  "tools\self-evolve\Generate-WeeklyReport.ps1" = "tools\self-evolve\Generate-WeeklyReport.ps1";
  "docs\self-evolve\GUARDRAILS.md" = "docs\self-evolve\GUARDRAILS.md";
  "docs\self-evolve\HumanGatePolicy.md" = "docs\self-evolve\HumanGatePolicy.md";
}
foreach($k in $map.Keys){
  $dst = Join-Path $repo $map[$k]
  New-Item -ItemType Directory -Force -Path (Split-Path $dst -Parent) | Out-Null
  Copy-Item -Path (Join-Path $root $k) -Destination $dst -Force
  Info "Installed: $($map[$k])"
}
Push-Location $repo
try {
  git add -A
  if (-not (git diff --cached --quiet)) { git commit -m "feat(self-evolve): guardrails + weekly reporting" }
  $remote = (git remote) | Select-Object -First 1
  if ($remote -and $OpenPR) {
    try { git push -u $remote HEAD } catch {}
    try { gh pr create --title "Self‑Evolve: guardrails + weekly reporting" --body "Adds caps, pause flags, weekly report." 2>$null | Out-Null } catch {}
  }
} finally { Pop-Location }