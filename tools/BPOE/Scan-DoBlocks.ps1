# Scan-DoBlocks.ps1 — validates fenced ```pwsh DO blocks for here-string hygiene
param([string]$Path = ".")
$ErrorActionPreference='Stop'
$bad = 0
$mds = Get-ChildItem -Path $Path -Recurse -File -Include *.md -ErrorAction SilentlyContinue
foreach($m in $mds){
  $content = Get-Content $m.FullName -Raw
  $blocks = [regex]::Matches($content, '(?s)```pwsh\n(.*?)\n```')
  for($bi=0; $bi -lt $blocks.Count; $bi++){
    $code = $blocks[$bi].Groups[1].Value -split "`r?`n"
    for($i=0; $i -lt $code.Count; $i++){
      $line = $code[$i]
      if($line -match "(@'|@\\\")\s*\S"){
        Write-Host "$($m.FullName):$($i+1) — here-string header must be alone"; $bad++
      }
      if($line -match "\S*\s*'@|\S*\s*\"@"){
        Write-Host "$($m.FullName):$($i+1) — here-string closer must be alone"; $bad++
      }
    }
  }
}
if($bad -gt 0){ exit 2 }
