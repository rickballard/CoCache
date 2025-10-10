param(
  [string]$RepoRoot = "$HOME\Documents\GitHub\CoCivium",
  [string]$BusRel   = "admin/session-bus/session_bus.jsonl"
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
function Need($n){ if(-not (Get-Command $n -ErrorAction SilentlyContinue)){ throw "Missing dependency: $n" } }
Need git

if(-not (Test-Path $RepoRoot)){ throw "Repo not found: $RepoRoot" }
if(-not (Test-Path (Join-Path $RepoRoot '.git'))){ throw "Not a git repo: $RepoRoot" }
Set-Location $RepoRoot

$remote = (git remote get-url origin).Trim()
if($remote -match "github\.com[:/](.+?)/(.+?)(?:\.git)?$"){ $Owner=$Matches[1]; $Repo=$Matches[2] } else { throw "Cannot parse origin: $remote" }
$Branch = (git rev-parse --abbrev-ref HEAD)
$RawRepoURL = "https://raw.githubusercontent.com/$Owner/$Repo/$Branch/$BusRel"

$Desktop = [Environment]::GetFolderPath('Desktop')
$Beacon  = Join-Path $Desktop "CoCivBus_Beacon.json"
if(-not (Test-Path $Beacon)){ throw "Beacon not found: $Beacon" }
$b = Get-Content $Beacon -Raw | ConvertFrom-Json
$b.bus_url = $RawRepoURL
($b | ConvertTo-Json -Depth 5) | Set-Content -Path $Beacon -Encoding UTF8

Write-Host "✅ Beacon updated to repo raw URL:"
Write-Host "   $RawRepoURL"
