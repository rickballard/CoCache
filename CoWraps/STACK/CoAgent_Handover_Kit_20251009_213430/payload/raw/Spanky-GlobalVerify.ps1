param(
  [string]$Downloads = (Join-Path $env:USERPROFILE "Downloads")
)
if (-not (Test-Path $Downloads)) { Write-Host "ERROR: $Downloads not found" -ForegroundColor Red; exit 1 }
$BaseRegex = '^(?:\.(\d+[a-z]?)[-_])?Spanky_.*\.zip$'
Add-Type -AssemblyName System.IO.Compression.FileSystem | Out-Null
function Open-Zip([string]$z){ $fs=[IO.File]::OpenRead($z); $zip=[IO.Compression.ZipArchive]::new($fs,[IO.Compression.ZipArchiveMode]::Read,$false); ,$fs,$zip }
function Entries($zip){ foreach($e in $zip.Entries){ [pscustomobject]@{FullName=($e.FullName -replace '\\','/').TrimStart('/');Length=$e.Length} } }
function FirstLine($zip,$entry){ $e=$zip.GetEntry($entry); if(-not $e){return $null}; $sr=[IO.StreamReader]::new($e.Open()); try{ $l=$sr.ReadLine(); if($l){$l.Trim()}} finally{$sr.Dispose()} }
function CountPref($present,$pref){ @($present | ?{ $_ -like "$pref*" -and -not $_.EndsWith('/') }).Count }
$req='_spanky/_copayload.meta.json','_spanky/_wrap.manifest.json','_spanky/checksums.json','_spanky/out.txt','transcripts/session.md'
$zips = Get-ChildItem -LiteralPath $Downloads -File -Force -Filter '*.zip' | ? { $_.Name -match $BaseRegex } | sort LastWriteTime -desc
if(-not $zips){ Write-Host "No Spanky zips in $Downloads" -ForegroundColor Yellow; exit 0 }
$rows=@()
foreach($zf in $zips){
  try{
    $fs,$zip = Open-Zip $zf.FullName
    try{
      $present=@(Entries $zip).FullName
      $missing=@(); foreach($r in $req){ if(-not ($present -contains $r)){ $missing+=$r } }
      $t=CountPref $present 'transcripts/'; $p=CountPref $present 'payload/'; $n=CountPref $present 'notes/'; $s=CountPref $present 'summaries/'
      $status=FirstLine $zip '_spanky/out.txt'; $mismatch=$null; $okCount=$false
      if($status -and $status -match '\[STATUS\]\s+items=(\d+)\s+transcripts=(\d+)\s+payload=(\d+)\s+notes=(\d+)\s+summaries=(\d+)'){
        $stT=[int]$Matches[2]; $stP=[int]$Matches[3]; $stN=[int]$Matches[4]; $stS=[int]$Matches[5]
        if(($stT -ne ($t+$p+$n+$s)) -or ($stP -ne $p) -or ($stN -ne $n) -or ($stS -ne $s)){ $mismatch="Counts mismatch: out.txt(T=$stT P=$stP N=$stN S=$stS) vs zip(T=$($t+$p+$n+$s) P=$p N=$n S=$s)" } else { $okCount=$true }
      }
      $verdict= if($missing.Count -eq 0){ if($mismatch){'OK*'} else {'OK'} } else {'MISSING'}
      $rows += [pscustomobject]@{ FileName=$zf.Name; FullPath=$zf.FullName; Modified=$zf.LastWriteTime; Verdict=$verdict;
        MissingRequired=($missing -join '; '); OutTxtStatus=$status; StatusCountsOK=$okCount; StatusMismatch=$mismatch;
        Transcripts=$t; Payload=$p; Notes=$n; Summaries=$s }
    } finally{ $zip.Dispose(); $fs.Dispose() }
  } catch {
    $rows += [pscustomobject]@{ FileName=$zf.Name; FullPath=$zf.FullName; Modified=$zf.LastWriteTime; Verdict='ERROR'; MissingRequired=$_.Exception.Message;
      OutTxtStatus=$null; StatusCountsOK=$false; StatusMismatch='zip open/read error'; Transcripts=0; Payload=0; Notes=0; Summaries=0 }
  }
}
$rows | sort Modified -desc | ft -AutoSize FileName,Verdict,Transcripts,Payload,Notes,Summaries,StatusCountsOK,StatusMismatch,Modified
foreach($r in ($rows | ?{ $_.Verdict -like 'OK*' -or $_.Verdict -eq 'OK' })){
  $counts = if($r.OutTxtStatus){ $r.OutTxtStatus } else { "[STATUS] items=? transcripts=$($r.Transcripts) payload=$($r.Payload) notes=$($r.Notes) summaries=$($r.Summaries)" }
  Write-Host "Spanky ready: $($r.FileName) ($counts)" -ForegroundColor Green
}