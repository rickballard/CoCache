param(
  [string[]]$ZipPaths,          # If omitted, auto-picks AdviceBomb_*.zip from Downloads
  [switch]$UseLfs               # Track *.zip with LFS if not already tracked
)
$ErrorActionPreference = "Stop"

function Get-Hash([string]$p){ (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash }
function SafeTag([string]$name){ (($name -replace '\.zip$','') -replace '[^a-zA-Z0-9\-_.]','-') }

# Locate repo root from this script's path
$REPO = Split-Path -Parent $PSScriptRoot
Set-Location $REPO
git fetch origin | Out-Null
if((git rev-parse --abbrev-ref HEAD).Trim() -ne "main"){ git checkout main | Out-Null }
git pull --ff-only | Out-Null

if($UseLfs){
  $needsTrack = -not (Test-Path ".gitattributes") -or -not (Select-String -Path ".gitattributes" -Pattern '\*\.zip filter=lfs' -Quiet)
  if($needsTrack){
    git lfs track "*.zip"
    git add .gitattributes
    git commit -m "chore(lfs): track zip artifacts" | Out-Null
    git push origin main | Out-Null
  }
}

# Inputs
if(-not $ZipPaths -or -not $ZipPaths.Count){
  $ZipPaths = Get-ChildItem "$HOME\Downloads\AdviceBomb_*.zip" -File -ErrorAction SilentlyContinue | ForEach-Object FullName
}
if(-not $ZipPaths -or -not $ZipPaths.Count){
  Write-Host "No ZIPs found. Provide -ZipPaths or drop files named AdviceBomb_*.zip in Downloads." -ForegroundColor Yellow
  exit 0
}

# Catalog helper
function Catalog-Zip([string]$ZipPath,[string]$PathInRepo,[string]$CatalogDir="advice-bombs/catalog"){
  $sha = Get-Hash $ZipPath
  $leaf = Split-Path $ZipPath -Leaf
  $stem = [IO.Path]::GetFileNameWithoutExtension($leaf)
  $tmp  = Join-Path $env:TEMP ("ab_" + [guid]::NewGuid().ToString("N"))
  New-Item -ItemType Directory -Path $tmp -Force | Out-Null
  try{
    Expand-Archive -LiteralPath $ZipPath -DestinationPath $tmp -Force
    $files  = Get-ChildItem $tmp -Recurse -File
    $sample = $files | Select-Object -First 200
    $items  = foreach($f in $sample){ [pscustomobject]@{ path=($f.FullName.Substring($tmp.Length).TrimStart('\','/') -replace '\\','/'); bytes=$f.Length } }
    $mani = [pscustomobject]@{
      name=$leaf; pathInRepo=$PathInRepo; sha256=$sha
      fileCount=($files | Measure-Object).Count
      topLevelDirs=(Get-ChildItem $tmp -Directory | Select-Object -First 10 | ForEach-Object Name)
      hasReadme=(Test-Path (Join-Path $tmp "README.md"))
      sampledItems=$items; createdUtc=(Get-Date).ToUniversalTime().ToString("o")
    }
    $catAbs = Join-Path $REPO $CatalogDir
    New-Item -ItemType Directory -Force -Path $catAbs | Out-Null
    $maniPath = Join-Path $catAbs ($stem + ".manifest.json")
    $mani | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $maniPath -Encoding UTF8
    return $maniPath
  } finally { Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue | Out-Null }
}

# Work dirs
$DEST_ROOT = "advice-bombs/raw"
$destDir   = Join-Path $REPO $DEST_ROOT
New-Item -ItemType Directory -Force -Path $destDir | Out-Null

$results = @()

foreach($src in $ZipPaths){
  if(-not (Test-Path -LiteralPath $src)){ Write-Warning "Missing: $src"; continue }
  $leaf = Split-Path $src -Leaf
  $dest = Join-Path $destDir $leaf
  $srcHash = Get-Hash $src

  # De-dupe: skip if any parked ZIP has same SHA256
  $dupe = Get-ChildItem $destDir -Filter *.zip -File -Recurse | Where-Object {
    (Get-FileHash -Algorithm SHA256 -LiteralPath $_.FullName).Hash -eq $srcHash
  }
  if($dupe){ Write-Host "Skip duplicate: $leaf" -ForegroundColor DarkYellow; continue }

  Copy-Item -LiteralPath $src -Destination $dest -Force
  git add -- $dest
  $ts = Get-Date -Format "yyyy-MM-dd HH:mm"
  $msg = "advice: park $leaf ($ts) [parking, cataloged, not integrated]"
  git commit -m $msg | Out-Null
  git push origin main | Out-Null

  # Catalog + commit manifest
  $maniPath = Catalog-Zip -ZipPath $dest -PathInRepo ("$DEST_ROOT/$leaf")
  git add -- $maniPath
  git commit -m "catalog: $leaf ($ts)" | Out-Null
  git push origin main | Out-Null

  # Tag (idempotent)
  $tag = "advicebomb/" + (SafeTag $leaf)
  $exists = (git ls-remote --tags origin | findstr /i "refs/tags/$tag$") -ne $null
  if($exists){ $tag += "-" + (Get-Date -Format "yyyyMMddHHmmss") }
  git tag -a $tag -m $msg
  try { git push origin $tag | Out-Null } catch { Write-Warning ("Tag push failed for {0}: {1}" -f $tag, $_.Exception.Message) }

  $results += [pscustomobject]@{ File=$leaf; Path="advice-bombs/raw/$leaf"; SHA256=$srcHash; Tag=$tag }
}

# Rebuild index from manifests every run
$manis = Get-ChildItem "advice-bombs\catalog\*.manifest.json" -File | ForEach-Object { Get-Content $_.FullName -Raw | ConvertFrom-Json }
$index = [pscustomobject]@{ generatedUtc=(Get-Date).ToUniversalTime().ToString("o"); items=$manis | Sort-Object name }
$index | ConvertTo-Json -Depth 6 | Set-Content "advice-bombs\index.json" -Encoding UTF8
git add advice-bombs/index.json
if(git diff --cached --name-only){ git commit -m "catalog: rebuild advice-bombs/index.json" | Out-Null; git push origin main | Out-Null }

if($results.Count){ $results | Format-Table -AutoSize } else { Write-Host "Nothing added (missing or duplicates)." -ForegroundColor Yellow }

