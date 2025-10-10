param(
  [string]$ZipPath,
  [string]$CoCacheRoot = "$env:USERPROFILE\Documents\GitHub\CoCache"
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
function Ensure-Dir($p){ if(-not (Test-Path $p)){ New-Item -ItemType Directory -Force -Path $p | Out-Null } }
function SafeName($s){ (($s -replace '\s+','_') -replace '[^\w\.\-]','_') }
function Get-Sha256([string]$path){
  $sha=[Security.Cryptography.SHA256]::Create()
  $fs=[IO.File]::OpenRead($path)
  try{ -join ($sha.ComputeHash($fs) | ForEach-Object { $_.ToString('x2') }) } finally { $fs.Dispose(); $sha.Dispose() }
}

if(-not (Test-Path $ZipPath)){ throw "Zip not found: $ZipPath" }

$stack = Join-Path $CoCacheRoot 'CoWraps\STACK'; Ensure-Dir $stack
$tmp = Join-Path $env:TEMP ("Raw2Spanky_" + [Guid]::NewGuid().Guid); Ensure-Dir $tmp
Expand-Archive -Path $ZipPath -DestinationPath $tmp -Force

$base   = [IO.Path]::GetFileNameWithoutExtension($ZipPath)
$target = Join-Path $stack (SafeName $base)

# fresh
if(Test-Path $target){ Remove-Item $target -Recurse -Force }
New-Item -ItemType Directory -Force -Path $target                        | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $target '_spanky')  | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $target 'transcripts')| Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $target 'notes')    | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $target 'payload\raw')| Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $target 'summaries')| Out-Null

# naive classification (fast, good enough for consolidation)
$notes=0; $trans=0; $payload=0; $summ=0
Get-ChildItem -Path $tmp -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
  $dest = Join-Path $target 'payload\raw'
  if($_.Name -match '(?i)session.*\.(md|txt)$'){ $dest = Join-Path $target 'transcripts'; $trans++ }
  elseif($_.Extension -match '(?i)\.(md|txt)$'){ $dest = Join-Path $target 'notes'; $notes++ }
  elseif($_.Extension -match '(?i)\.(json|csv)$' -and $_.Name -match '(?i)summary|tldr'){ $dest = Join-Path $target 'summaries'; $summ++ }
  else { $payload++ }
  Copy-Item $_.FullName -Destination (Join-Path $dest $_.Name) -Force
}

$items = $notes + $trans + $payload + $summ
$meta = @{
  source_zip     = [IO.Path]::GetFileName($ZipPath)
  session_title  = $base
  wrap_version   = '2.0-raw-repack'
  created_utc    = (Get-Date).ToUniversalTime().ToString('o')
  source_sha256  = Get-Sha256 $ZipPath
}
$manifest = @{
  generator      = 'Convert-RawZipToSpanky.ps1'
  counts         = @{ items=$items; transcripts=$trans; payload=$payload; notes=$notes; summaries=$summ }
}
$meta     | ConvertTo-Json -Depth 6 | Set-Content (Join-Path $target '_spanky\_copayload.meta.json') -Encoding UTF8
$manifest | ConvertTo-Json -Depth 6 | Set-Content (Join-Path $target '_spanky\_wrap.manifest.json') -Encoding UTF8
"[STATUS] items=$items transcripts=$trans payload=$payload notes=$notes summaries=$summ" | Set-Content (Join-Path $target '_spanky\out.txt') -Encoding UTF8
"# CoWrap placement`nDrop-in: CoCache/CoWraps/STACK/$(SafeName $base)/" | Set-Content (Join-Path $target 'README_PLACEMENT.md') -Encoding UTF8

Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Repacked -> $target"
