[CmdletBinding()]
param(
  [Parameter(Mandatory)][string]$Name,
  [Parameter(Mandatory)][string[]]$Paths,
  [string]$RepoPath = "$HOME\Documents\GitHub\CoAgent",
  [string]$Session = $env:COAGENT_SESSION,
  [int]$DaysToLive = 7
)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
function Info($m){ Write-Host "[INFO] $m" }

Add-Type -AssemblyName System.IO.Compression.FileSystem

$repo = Resolve-Path $RepoPath -ErrorAction SilentlyContinue
if (-not $repo) { throw "Repo not found: $RepoPath" }

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$base  = Join-Path $HOME "CoTemps"
$slug  = "{0}-{1}-{2}-{3}" -f (Split-Path -Leaf $repo), ($Session -replace '[^\w.-]','_'), $stamp, ($Name -replace '[^\w.-]','_')
$stage = Join-Path $base $slug
$zip   = Join-Path $base ($slug + ".zip")

New-Item -ItemType Directory -Force -Path $stage,$base | Out-Null

foreach($p in $Paths){
  $abs = Resolve-Path $p -ErrorAction SilentlyContinue
  if (-not $abs) { Write-Warning "Path not found: $p"; continue }
  $fi = Get-Item $abs
  if ($fi.PSIsContainer) {
    Copy-Item -Path $fi.FullName -Destination (Join-Path $stage $fi.Name) -Recurse -Force
  } else {
    Copy-Item -Path $fi.FullName -Destination (Join-Path $stage $fi.Name) -Force
  }
}

if (Test-Path $zip) { Remove-Item $zip -Force }
[System.IO.Compression.ZipFile]::CreateFromDirectory($stage, $zip, [System.IO.Compression.CompressionLevel]::Optimal, $false)

# TTL note
"EXPIRES: $((Get-Date).AddDays($DaysToLive).ToString('yyyy-MM-dd HH:mm:ss'))" |
  Set-Content -Encoding UTF8 (Join-Path $base ($slug + ".ttl.txt"))

# cleanup stage
try { Remove-Item $stage -Recurse -Force -ErrorAction Stop } catch {}

Info "Artifact: $zip"
Write-Host "Download: $zip"
