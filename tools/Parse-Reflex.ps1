param(
  [Parameter(Mandatory)][string]$StagePath,   # folder OR .zip containing DO_SmokeTest_*.ps1 outputs
  [Parameter(Mandatory)][string]$AssetId,     # e.g. "RickPublic/SOTW" or "CoAgent/mvp3"
  [Parameter(Mandatory)][string]$Version      # e.g. "v1.0.0" or commit/tag
)
$ErrorActionPreference="Stop"
function Get-Sha256([string]$p){ (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash }

# If zip, expand to temp
$root = $StagePath
if($StagePath -match '\.zip$'){
  $tmp = Join-Path $env:TEMP ("reflex_unpack_" + [guid]::NewGuid())
  New-Item -ItemType Directory -Force -Path $tmp | Out-Null
  Expand-Archive -LiteralPath $StagePath -DestinationPath $tmp -Force
  $root = $tmp
}

# Find outputs
$out  = (Get-ChildItem -Path $root -Recurse -File |
  Where-Object { param(
  [Parameter(Mandatory)][string]$StagePath,   # folder OR .zip containing DO_SmokeTest_*.ps1 outputs
  [Parameter(Mandatory)][string]$AssetId,     # e.g. "RickPublic/SOTW" or "CoAgent/mvp3"
  [Parameter(Mandatory)][string]$Version      # e.g. "v1.0.0" or commit/tag
)
$ErrorActionPreference="Stop"
function Get-Sha256([string]$p){ (Get-FileHash -Algorithm SHA256 -LiteralPath $p).Hash }

# If zip, expand to temp
$root = $StagePath
if($StagePath -match '\.zip$'){
  $tmp = Join-Path $env:TEMP ("reflex_unpack_" + [guid]::NewGuid())
  New-Item -ItemType Directory -Force -Path $tmp | Out-Null
  Expand-Archive -LiteralPath $StagePath -DestinationPath $tmp -Force
  $root = $tmp
}

# Find outputs
$out  = Get-ChildItem -Path $root -Recurse -Filter "out.txt" -File | Select-Object -First 1
$sig  = Get-ChildItem -Path $root -Recurse -Filter "*.sig.json" -File | Select-Object -First 1
if(-not $out){
  $CC   = Join-Path $HOME "Documents\GitHub\CoCache"
  $LogDir = Join-Path $CC "status\log"; New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
  $Jsonl  = Join-Path $LogDir ("cosync_{0}.jsonl" -f (Get-Date -Format "yyyyMMdd"))
  $entry  = [pscustomobject]@{
    repo="CoCache"; commit=(git -C $CC rev-parse --short HEAD);
    when=(Get-Date).ToString("o"); area="reflex"; type="alert";
    summary="Reflex missing output"; data=@{ root=$root }
  }
  (($entry | ConvertTo-Json -Depth 8) + "`n") | Add-Content -LiteralPath $Jsonl -Encoding UTF8
  Write-Host "⚠ Reflex: no output found under $root — logged alert."; return
}

$hash = Get-Sha256 $out.FullName
$size = (Get-Item $out.FullName).Length

# Persist known hash: CoCache/docs/reflex/hashes/<AssetId>/<Version>.json
$CC   = Join-Path $HOME "Documents\GitHub\CoCache"
$dstD = Join-Path $CC ("docs\reflex\hashes\" + ($AssetId -replace '[\\/]', '_'))
New-Item -ItemType Directory -Force -Path $dstD | Out-Null
$dstF = Join-Path $dstD ("{0}.json" -f ($Version -replace '[^\w\.\-\+]', '_'))

$record = [pscustomobject]@{
  asset   = $AssetId
  version = $Version
  when    = (Get-Date).ToString("o")
  out     = @{ sha256=$hash; bytes=$size; relPath=$(({Split-Path $out.FullName -Leaf})) }
  sig     = if($sig){ Get-Content $sig.FullName -Raw | ConvertFrom-Json } else { $null }
}
$record | ConvertTo-Json -Depth 10 | Set-Content -Encoding UTF8 -LiteralPath $dstF

# Log to shared receipts
$LogDir = Join-Path $CC "status\log"; New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$Jsonl  = Join-Path $LogDir ("cosync_{0}.jsonl" -f (Get-Date -Format "yyyyMMdd"))
$entry  = [pscustomobject]@{
  repo="CoCache"; commit=(git -C $CC rev-parse --short HEAD)
  when=(Get-Date).ToString("o"); area="reflex"; type="progress"
  summary="Reflex parsed"
  data=@{ asset=$AssetId; version=$Version; sha256=$hash; bytes=$size }
}
(($entry | ConvertTo-Json -Depth 8) + "`n") | Add-Content -LiteralPath $Jsonl -Encoding UTF8

if($tmp){ Remove-Item -Recurse -Force $tmp }
Write-Host ("✔ Reflex captured: {0}@{1}  SHA256={2}  {3:N0} bytes" -f $AssetId,$Version,$hash,$size)
.Name -match '^(out|output|reflex)[\._\-]?(txt|log)
$sig  = Get-ChildItem -Path $root -Recurse -Filter "*.sig.json" -File | Select-Object -First 1
if(-not $out){
  $CC   = Join-Path $HOME "Documents\GitHub\CoCache"
  $LogDir = Join-Path $CC "status\log"; New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
  $Jsonl  = Join-Path $LogDir ("cosync_{0}.jsonl" -f (Get-Date -Format "yyyyMMdd"))
  $entry  = [pscustomobject]@{
    repo="CoCache"; commit=(git -C $CC rev-parse --short HEAD);
    when=(Get-Date).ToString("o"); area="reflex"; type="alert";
    summary="Reflex missing output"; data=@{ root=$root }
  }
  (($entry | ConvertTo-Json -Depth 8) + "`n") | Add-Content -LiteralPath $Jsonl -Encoding UTF8
  Write-Host "⚠ Reflex: no output found under $root — logged alert."; return
}

$hash = Get-Sha256 $out.FullName
$size = (Get-Item $out.FullName).Length

# Persist known hash: CoCache/docs/reflex/hashes/<AssetId>/<Version>.json
$CC   = Join-Path $HOME "Documents\GitHub\CoCache"
$dstD = Join-Path $CC ("docs\reflex\hashes\" + ($AssetId -replace '[\\/]', '_'))
New-Item -ItemType Directory -Force -Path $dstD | Out-Null
$dstF = Join-Path $dstD ("{0}.json" -f ($Version -replace '[^\w\.\-\+]', '_'))

$record = [pscustomobject]@{
  asset   = $AssetId
  version = $Version
  when    = (Get-Date).ToString("o")
  out     = @{ sha256=$hash; bytes=$size; relPath=$(({Split-Path $out.FullName -Leaf})) }
  sig     = if($sig){ Get-Content $sig.FullName -Raw | ConvertFrom-Json } else { $null }
}
$record | ConvertTo-Json -Depth 10 | Set-Content -Encoding UTF8 -LiteralPath $dstF

# Log to shared receipts
$LogDir = Join-Path $CC "status\log"; New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$Jsonl  = Join-Path $LogDir ("cosync_{0}.jsonl" -f (Get-Date -Format "yyyyMMdd"))
$entry  = [pscustomobject]@{
  repo="CoCache"; commit=(git -C $CC rev-parse --short HEAD)
  when=(Get-Date).ToString("o"); area="reflex"; type="progress"
  summary="Reflex parsed"
  data=@{ asset=$AssetId; version=$Version; sha256=$hash; bytes=$size }
}
(($entry | ConvertTo-Json -Depth 8) + "`n") | Add-Content -LiteralPath $Jsonl -Encoding UTF8

if($tmp){ Remove-Item -Recurse -Force $tmp }
Write-Host ("✔ Reflex captured: {0}@{1}  SHA256={2}  {3:N0} bytes" -f $AssetId,$Version,$hash,$size)
 }) | Select-Object -First 1
$sig  = Get-ChildItem -Path $root -Recurse -Filter "*.sig.json" -File | Select-Object -First 1
if(-not $out){
  $CC   = Join-Path $HOME "Documents\GitHub\CoCache"
  $LogDir = Join-Path $CC "status\log"; New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
  $Jsonl  = Join-Path $LogDir ("cosync_{0}.jsonl" -f (Get-Date -Format "yyyyMMdd"))
  $entry  = [pscustomobject]@{
    repo="CoCache"; commit=(git -C $CC rev-parse --short HEAD);
    when=(Get-Date).ToString("o"); area="reflex"; type="alert";
    summary="Reflex missing output"; data=@{ root=$root }
  }
  (($entry | ConvertTo-Json -Depth 8) + "`n") | Add-Content -LiteralPath $Jsonl -Encoding UTF8
  Write-Host "⚠ Reflex: no output found under $root — logged alert."; return
}

$hash = Get-Sha256 $out.FullName
$size = (Get-Item $out.FullName).Length

# Persist known hash: CoCache/docs/reflex/hashes/<AssetId>/<Version>.json
$CC   = Join-Path $HOME "Documents\GitHub\CoCache"
$dstD = Join-Path $CC ("docs\reflex\hashes\" + ($AssetId -replace '[\\/]', '_'))
New-Item -ItemType Directory -Force -Path $dstD | Out-Null
$dstF = Join-Path $dstD ("{0}.json" -f ($Version -replace '[^\w\.\-\+]', '_'))

$record = [pscustomobject]@{
  asset   = $AssetId
  version = $Version
  when    = (Get-Date).ToString("o")
  out     = @{ sha256=$hash; bytes=$size; relPath=$(({Split-Path $out.FullName -Leaf})) }
  sig     = if($sig){ Get-Content $sig.FullName -Raw | ConvertFrom-Json } else { $null }
}
$record | ConvertTo-Json -Depth 10 | Set-Content -Encoding UTF8 -LiteralPath $dstF

# Log to shared receipts
$LogDir = Join-Path $CC "status\log"; New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$Jsonl  = Join-Path $LogDir ("cosync_{0}.jsonl" -f (Get-Date -Format "yyyyMMdd"))
$entry  = [pscustomobject]@{
  repo="CoCache"; commit=(git -C $CC rev-parse --short HEAD)
  when=(Get-Date).ToString("o"); area="reflex"; type="progress"
  summary="Reflex parsed"
  data=@{ asset=$AssetId; version=$Version; sha256=$hash; bytes=$size }
}
(($entry | ConvertTo-Json -Depth 8) + "`n") | Add-Content -LiteralPath $Jsonl -Encoding UTF8

if($tmp){ Remove-Item -Recurse -Force $tmp }
Write-Host ("✔ Reflex captured: {0}@{1}  SHA256={2}  {3:N0} bytes" -f $AssetId,$Version,$hash,$size)

