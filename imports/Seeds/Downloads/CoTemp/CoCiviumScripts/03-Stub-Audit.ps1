. "$PSScriptRoot/RepoConfig.ps1"
$ErrorActionPreference='Stop'
function WordCount([string]$s){ if([string]::IsNullOrEmpty($s)){0}else{ ([regex]::Matches($s,'\b[\p{L}\p{N}][\p{L}\p{N}\-\'']*\b','IgnoreCase')).Count } }
function IsCanon($p){ foreach($c in $CanonKeep){ if($p -like "*$c*"){return $true} } $false }

Push-Location $Repo
try{
  $docExts = ".md",".markdown",".txt",".rst",".adoc",".html",".htm"
  $textDocs = Get-ChildItem -Recurse -File | ? { $docExts -contains $_.Extension.ToLowerInvariant() }
  $stubs = [System.Collections.Generic.List[object]]::new()
  foreach($f in $textDocs){
    $raw = Get-Content -Raw -LiteralPath $f.FullName -ErrorAction SilentlyContinue
    if($null -eq $raw){ Write-Host "skip (unreadable): $($f.FullName)" -ForegroundColor DarkGray; continue }
    $wc = WordCount $raw
    if($wc -lt $StubThreshold){
      $stubs.Add([pscustomobject]@{File=$f.FullName;Words=$wc})
      if($f.Extension -in @(".md",".markdown") -and -not (IsCanon $f.FullName)){
        if($raw -notmatch '<!--\s*status:\s*stub\s*-->'){
          "<!-- status: stub; target: ${StubThreshold}+ words -->`r`n$raw" | Set-Content -Encoding UTF8 -LiteralPath $f.FullName
        }
      }
    }
  }
  $statusDir = Join-Path $Repo "docs\status"; [IO.Directory]::CreateDirectory($statusDir)|Out-Null
  $ts = (Get-Date).ToUniversalTime().ToString('yyyy-MM-dd_HHmmssZ')
  if($stubs.Count -gt 0){
    $csv = Join-Path $statusDir "stubs-$ts.csv"
    $stubs | Sort-Object Words | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $csv
  }
  git add docs/status; git commit -m "status: stub audit (threshold=$StubThreshold)" 2>$null | Out-Null
  Write-Host "Stub count: $($stubs.Count)"
} finally { Pop-Location }
