Set-StrictMode -Version Latest
$ErrorActionPreference="Stop"; $ProgressPreference="SilentlyContinue"
$GH       = Join-Path $HOME "Documents\GitHub"
$CoCache  = Join-Path $GH   "CoCache"
$Advice   = Join-Path $CoCache "advice"
$Inbox    = Join-Path $Advice  "inbox"
$ProcRoot = Join-Path $CoCache "docs\intent\advice"
$Processed= Join-Path $ProcRoot "processed"
$IndexDir = Join-Path $ProcRoot "index"
$Archive  = Join-Path $ProcRoot "archive"
Add-Type -AssemblyName System.IO.Compression.FileSystem | Out-Null
function NormTitle([string]$s){ if([string]::IsNullOrWhiteSpace($s)){return $null}; ($s -replace '[^\w\- ]','' ).Trim() }
$stamp=(Get-Date).ToString("yyyy-MM-ddTHH-mm-ss")
$ingested=@()
$candidates = Get-ChildItem $Inbox -File -ErrorAction SilentlyContinue
foreach($f in $candidates){
  try{
    $destOrig = Join-Path $Archive ("{0}_{1}" -f $stamp,$f.Name)
    Copy-Item -LiteralPath $f.FullName -Destination $destOrig -Force
    $payloads=@()
    if($f.Extension -ieq ".zip"){
      $tmp = Join-Path ([IO.Path]::GetTempPath()) ("adv_" + [Guid]::NewGuid().ToString("N"))
      New-Item -ItemType Directory -Force -Path $tmp | Out-Null
      [IO.Compression.ZipFile]::ExtractToDirectory($f.FullName,$tmp)
      $payloads = Get-ChildItem $tmp -Recurse -File | Where-Object { $_.Extension -in ".md",".txt",".json" }
    } else { $payloads = @($f) }
    foreach($p in $payloads){
      $base = [IO.Path]::GetFileNameWithoutExtension($p.Name)
      $ext  = $p.Extension
      $safe = "{0}_{1}{2}" -f $stamp, ($base -replace '[^\w\-]' , '-'), $ext
      $out  = Join-Path $Processed $safe
      Copy-Item -LiteralPath $p.FullName -Destination $out -Force
      $ingested += [pscustomobject]@{ ts=$stamp; src=$f.FullName; out=$out; name=$p.Name; ext=$ext }
    }
    Remove-Item -LiteralPath $f.FullName -Force
  } catch { Write-Warning ("Advice ingest failed for {0}: {1}" -f $f.FullName, $_.Exception.Message) }
}
$idxJson = Join-Path $IndexDir "advice.index.json"
$current = @()
if(Test-Path $idxJson){ try{ $current = Get-Content $idxJson -Raw | ConvertFrom-Json } catch { $current=@() } }
$current = @($current) + @($ingested)
$current | ConvertTo-Json -Depth 6 | Out-File -Encoding utf8 $idxJson
$idxMd = Join-Path $IndexDir "advice.index.md"
$lines=@("# Advice Index (auto)","")
$take = $current | Sort-Object ts -Descending
foreach($r in $take){ $lines += ("- {0} — {1}" -f $r.ts, $r.out) }
$lines -join "`r`n" | Out-File -Encoding utf8 $idxMd
Write-Host ("Advice integrated: {0} new file(s)" -f ($ingested.Count))

