param([string]$Path='.')
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
$files = Get-ChildItem -Path $Path -Recurse -Filter *.md
$missing = @()
foreach($f in $files){
  $t = Get-Content -Raw -Path $f.FullName
  if($t -match '---\s*(.*?)\s*---'){
    $front = $Matches[1]
    foreach($k in @('id','slug','title','version','status','domain','created','updated')){
      if($front -notmatch "(?m)^\s*${k}\s*:\s*"){ $missing += [PSCustomObject]@{File=$f.FullName; Missing=$k} }
    }
  }
}
if($missing){ $missing | Format-Table -AutoSize; Write-Error "Front matter missing required keys." } else { Write-Host "All exemplar files passed basic lint." -ForegroundColor Green }

