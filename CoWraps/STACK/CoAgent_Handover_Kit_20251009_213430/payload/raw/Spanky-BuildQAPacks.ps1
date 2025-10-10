param(
  [string]$Downloads = (Join-Path $env:USERPROFILE "Downloads")
)
if (-not (Test-Path $Downloads)) { Write-Host "ERROR: $Downloads not found" -ForegroundColor Red; exit 1 }
$stamp = (Get-Date).ToString('yyyyMMdd_HHmmss')
$qaRoot = Join-Path $Downloads ("Spanky_QA_Packs_{0}" -f $stamp)
New-Item -ItemType Directory -Force -Path $qaRoot | Out-Null

$csv = Get-ChildItem -LiteralPath $Downloads -Filter 'Spanky_Rework_Queue_*.csv' -File -ErrorAction SilentlyContinue | sort LastWriteTime -desc | select -First 1
$bad = @()
if ($csv) { try { $bad = Import-Csv -LiteralPath $csv | ? { $_.Verdict -ne 'OK' } } catch { $bad=@() } }

if (-not $bad -or $bad.Count -eq 0) {
  $BaseRegex = '^(?:\.(\d+[a-z]?)[-_])?Spanky_.*\.zip$'
  Add-Type -AssemblyName System.IO.Compression.FileSystem | Out-Null
  function Open-Zip([string]$z){ $fs=[IO.File]::OpenRead($z); $zip=[IO.Compression.ZipArchive]::new($fs,[IO.Compression.ZipArchiveMode]::Read,$false); ,$fs,$zip }
  function Entries($zip){ foreach($e in $zip.Entries){ [pscustomobject]@{FullName=($e.FullName -replace '\\','/').TrimStart('/')} } }
  function FirstLine($zip,$entry){ $e=$zip.GetEntry($entry); if(-not $e){return $null}; $sr=[IO.StreamReader]::new($e.Open()); try{ $l=$sr.ReadLine(); if($l){$l.Trim()}} finally{$sr.Dispose()} }
  function CountPref($present,$pref){ @($present | ?{ $_ -like "$pref*" -and -not $_.EndsWith('/') }).Count }
  $req='_spanky/_copayload.meta.json','_spanky/_wrap.manifest.json','_spanky/checksums.json','_spanky/out.txt','transcripts/session.md'
  $zips=Get-ChildItem -LiteralPath $Downloads -File -Force -Filter '*.zip' | ?{ $_.Name -match $BaseRegex }
  foreach($zf in $zips){
    try{
      $fs,$zip=Open-Zip $zf.FullName
      try{
        $present=@(Entries $zip).FullName
        $missing=@(); foreach($r in $req){ if(-not ($present -contains $r)){ $missing+=$r } }
        $t=CountPref $present 'transcripts/'; $p=CountPref $present 'payload/'; $n=CountPref $present 'notes/'; $s=CountPref $present 'summaries/'
        $status=FirstLine $zip '_spanky/out.txt'
        $mismatch=$false
        if($status -and $status -match '\[STATUS\]\s+items=(\d+)\s+transcripts=(\d+)\s+payload=(\d+)\s+notes=(\d+)\s+summaries=(\d+)'){
          if(([int]$Matches[2]) -ne ($t+$p+$n+$s) -or ([int]$Matches[3]) -ne $p -or ([int]$Matches[4]) -ne $n -or ([int]$Matches[5]) -ne $s){ $mismatch=$true }
        }
        $verdict= if($missing.Count -eq 0){ if($mismatch){'OK*'} else {'OK'} } else {'MISSING'}
        if($verdict -ne 'OK'){ $bad += [pscustomobject]@{ FileName=$zf.Name; FullPath=$zf.FullName; Verdict=$verdict } }
      } finally{ $zip.Dispose(); $fs.Dispose() }
    } catch { $bad += [pscustomobject]@{ FileName=$zf.Name; FullPath=$zf.FullName; Verdict='ERROR' } }
  }
}

if (-not $bad -or $bad.Count -eq 0) { Write-Host "All Spanky zips appear OK. No QA packs needed." -ForegroundColor Green; exit 0 }

Add-Type -AssemblyName System.IO.Compression.FileSystem | Out-Null
function Extract-IfPresent([string]$zipPath,[string]$entry,[string]$dst){
  try{
    $fs=[IO.File]::OpenRead($zipPath); $zip=[IO.Compression.ZipArchive]::new($fs,[IO.Compression.ZipArchiveMode]::Read,$false)
    try{
      $e=$zip.GetEntry($entry); if(-not $e){return $null}
      $out=Join-Path (Split-Path $dst) (Split-Path $entry -Leaf)
      $s=$e.Open(); $fo=[IO.File]::Create($out); try{ $s.CopyTo($fo) } finally{ $fo.Dispose(); $s.Dispose() }
      return $out
    } finally{ $zip.Dispose(); $fs.Dispose() }
  } catch { return $null }
}

foreach($row in $bad){
  $zipPath=$row.FullPath; if(-not (Test-Path $zipPath)){ continue }
  $key = (($row.FileName -replace '^(?:\.(\d+[a-z]?)[-_])?Spanky_','') -replace '_\d{8}_\d{6}\.zip$','' -split '_')[0]
  $pack= Join-Path $qaRoot ($row.FileName -replace '\.zip$','')
  New-Item -ItemType Directory -Force -Path $pack | Out-Null
  Copy-Item -LiteralPath $zipPath -Destination (Join-Path $pack (Split-Path $zipPath -Leaf)) -Force
  Extract-IfPresent $zipPath '_spanky/out.txt'            (Join-Path $pack 'out.txt')           | Out-Null
  Extract-IfPresent $zipPath '_spanky/_wrap.manifest.json'(Join-Path $pack '_wrap.manifest.json')| Out-Null

@"
# DO: Self-verify & repair deliverable (READ-ONLY first, then rebuild)
`$SessionKey = '$key'
`$Basic = Join-Path `$env:USERPROFILE 'Downloads\Verify-SpankyDeliverables.ps1'
`$Deep  = Join-Path `$env:USERPROFILE 'Downloads\Spanky-GlobalVerify.ps1'
if (Test-Path `$Deep) { & `$Deep } elseif (Test-Path `$Basic) { & `$Basic -SessionKey `$SessionKey } else {
  Write-Host 'Missing verifiers in Downloads. Use ops scripts from CoAgent.' -ForegroundColor Yellow
}
# If MISSING/ERROR or counts mismatch persists:
#   1) Rebuild your Spanky_$key_<timestamp>.zip
#   2) Ensure _spanky/out.txt first line matches actual counts.
#   3) Re-run verify and post the 'Spanky ready: ...' line.
"@ | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $pack 'CoPing.ps1')

@"
# QA PROMPT — $key (Self-Assessment by Session)
0) Structural sanity: required files + out.txt counts + checksums.
1) Intent completeness: scope, audience, deliverables; tag (Unfinished).
2) Traceability: decisions link to sources/commits/issues; SOURCES.md up to date.
3) Coherence: de-duplicate; move stale to DEPRECATED.md with pointers.
4) Faces: AI-face concise & link-rich; Human-face navigable & visual; update WEBSITE_MANIFEST.md.
5) Exit: rebuild zip, re-verify, emit fresh “Spanky ready …” line.
"@ | Set-Content -Encoding UTF8 -LiteralPath (Join-Path $pack 'QA_PROMPT.md')
}

Write-Host "QA packs ready under: $qaRoot" -ForegroundColor Green