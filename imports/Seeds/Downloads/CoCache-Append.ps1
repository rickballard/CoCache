param(
  [Parameter(Mandatory=$true)][string]$Status,
  [string]$RepoRoot = "$HOME\Documents\GitHub\CoCivium",
  [string]$BusRel   = "admin/session-bus/session_bus.jsonl",
  [string]$Session  = "Main",
  [string]$Author   = $env:UserName
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
function Need($n){ if(-not (Get-Command $n -ErrorAction SilentlyContinue)){ throw "Missing dependency: $n" } }

Need git
# gh is only needed if we mirror to a Gist
$HasGh = $true; try { Need gh } catch { $HasGh = $false }

# Ensure repo
if(-not (Test-Path $RepoRoot)){ throw "Repo not found: $RepoRoot" }
if(-not (Test-Path (Join-Path $RepoRoot '.git'))){ throw "Not a git repo: $RepoRoot" }
Set-Location $RepoRoot

# Resolve origin/branch for raw URL
$remote = (git remote get-url origin).Trim()
if($remote -match "github\.com[:/](.+?)/(.+?)(?:\.git)?$"){ $Owner=$Matches[1]; $Repo=$Matches[2] } else { throw "Cannot parse origin: $remote" }
try {
  $Branch = (gh repo view "$Owner/$Repo" --json defaultBranchRef -q ".defaultBranchRef.name")
} catch { $Branch = (git symbolic-ref --short HEAD) }
if(-not $Branch){ $Branch = (git rev-parse --abbrev-ref HEAD) }

# Append JSONL line to repo file
$BusAbs = Join-Path $RepoRoot $BusRel
$dir = Split-Path $BusAbs -Parent; if(-not (Test-Path $dir)){ New-Item -ItemType Directory -Force -Path $dir | Out-Null }
$ts = (Get-Date).ToString("s")
$line = (@{
  ts      = "$ts"
  author  = "$Author"
  session = "$Session"
  status  = "$Status"
  todos   = @()
} | ConvertTo-Json -Compress)

Add-Content -Path $BusAbs -Value $line
git add -- "$BusRel"
git commit -m "bus: $($Status.Substring(0, [Math]::Min($Status.Length, 72)))" | Out-Null
git push | Out-Null

# If the Desktop beacon points to a Gist, attempt to mirror
$Desktop = [Environment]::GetFolderPath('Desktop')
$Beacon  = Join-Path $Desktop "CoCivBus_Beacon.json"
if(Test-Path $Beacon){
  try {
    $b = Get-Content $Beacon -Raw | ConvertFrom-Json
    $url = [string]$b.bus_url
    if($url -match "https://gist\.githubusercontent\.com/.+?/([0-9a-f]{20,})/raw/"){
      if(-not $HasGh){ Write-Warning "Beacon uses Gist but GitHub CLI (gh) not found. Skipping gist mirror."; return }
      $GistId = $Matches[1]
      # Prepare full content and update gist via API
      $content = Get-Content $BusAbs -Raw -Encoding UTF8
      $tmp = New-TemporaryFile
      $body = @{ files = @{ "session_bus.jsonl" = @{ content = $content } } } | ConvertTo-Json -Depth 5
      Set-Content -Path $tmp -Value $body -Encoding UTF8
      gh api -X PATCH "gists/$GistId" -H "Accept: application/vnd.github+json" --input "$tmp" | Out-Null
      Remove-Item $tmp -Force
      Write-Host "✅ Gist $GistId mirrored."
    }
  } catch {
    Write-Warning "Gist mirror attempt failed: $($_.Exception.Message)"
  }
}

$RawRepoURL = "https://raw.githubusercontent.com/$Owner/$Repo/$Branch/$BusRel"
Write-Host "✅ Appended. Raw repo URL: $RawRepoURL"
