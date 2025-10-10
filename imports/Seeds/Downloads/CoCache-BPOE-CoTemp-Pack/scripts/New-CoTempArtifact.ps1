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

$repo = Resolve-Path $RepoPath -ErrorAction SilentlyContinue
if (-not $repo) { throw "Repo not found: $RepoPath" }
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$base  = Join-Path $HOME "CoTemps"
New-Item -ItemType Directory -Force -Path $base | Out-Null
$slug = "{0}-{1}-{2}-{3}" -f (Split-Path -Leaf $repo), ($Session -replace '[^\w.-]','_'), $stamp, ($Name -replace '[^\w.-]','_')
$zip  = Join-Path $base ($slug + ".zip")

Add-Type -AssemblyName System.IO.Compression.FileSystem
if (Test-Path $zip) { Remove-Item $zip -Force }
$fs = [System.IO.File]::Open($zip, [System.IO.FileMode]::CreateNew)
$archive = New-Object System.IO.Compression.ZipArchive($fs, [System.IO.Compression.ZipArchiveMode]::Create)
try {
  foreach($p in $Paths){
    $abs = Resolve-Path $p -ErrorAction SilentlyContinue
    if (-not $abs) { Write-Warning "Path not found: $p"; continue }
    $fi = Get-Item $abs
    if ($fi.PSIsContainer) {
      $root = $fi.FullName
      Get-ChildItem -Path $root -Recurse -File | ForEach-Object {
        $entryName = $_.FullName.Substring($root.Length).TrimStart('\','/')
        $entry = $archive.CreateEntry((Join-Path ($fi.Name) $entryName) -replace '\\','/')
        $in = [System.IO.File]::OpenRead($_.FullName)
        $out = $entry.Open(); $in.CopyTo($out); $out.Dispose(); $in.Dispose()
      }
    } else {
      $entry = $archive.CreateEntry($fi.Name)
      $in = [System.IO.File]::OpenRead($fi.FullName)
      $out = $entry.Open(); $in.CopyTo($out); $out.Dispose(); $in.Dispose()
    }
  }
} finally { $archive.Dispose(); $fs.Dispose() }

$meta = Join-Path $base ($slug + ".ttl.txt")
$expiry = (Get-Date).AddDays($DaysToLive)
"EXPIRES: $($expiry.ToString('yyyy-MM-dd HH:mm:ss'))" | Set-Content -Encoding UTF8 $meta

Info "Artifact: $zip"
Write-Host "Download: $zip"
