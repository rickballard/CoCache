# tools/BPOE/Lint-HereStrings.ps1 — fails if here-strings are malformed or prompt cruft is present
param(
  [string]$Root = ".",
  [string[]]$Include = @("*.ps1","*.psm1","*.md")
)

$ErrorActionPreference='Stop'
$HereHeader = '^\s*@''\s*$'
$HereFooter = '^\s*''@\s*$'
$BadHeader  = '\s*@''.+$'
$BadFooter  = '^.+''@\s*$'
$PromptLine = '^\s*(PS\s+[A-Z]:\\|>>)\b'

$fail = $false
$files = Get-ChildItem -Path $Root -Recurse -File -Include $Include -ErrorAction SilentlyContinue
foreach($f in $files){
  $lines = Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue  | Out-String -Stream
  if(-not $lines){ continue }
  $open  = @()
  for($i=0;$i -lt $lines.Count;$i++){
    $L=$lines[$i]
    if($L -match $PromptLine){ Write-Host "::warning file=$($f.FullName),line=$($i+1)::prompt cruft (`"$L`")"; }
    if($L -match $BadHeader ){ Write-Host "::error file=$($f.FullName),line=$($i+1)::@' must be alone on its line"; $fail=$true }
    if($L -match $BadFooter ){ Write-Host "::error file=$($f.FullName),line=$($i+1)::'@ must be alone on its line"; $fail=$true }
    if($L -match $HereHeader){ $open += $i }
    if($L -match $HereFooter){
      if($open.Count){ $null = $open[0..($open.Count-2)]; $open=@() }
      else{ Write-Host "::error file=$($f.FullName),line=$($i+1)::stray here-string footer"; $fail=$true }
    }
  }
  if($open.Count){
    Write-Host "::error file=$($f.FullName),line=$($open[0]+1)::unclosed here-string opened here"
    $fail=$true
  }
}
if($fail){ exit 1 }