param([string]$Target = "Insights/BN_Story_being-noname_v1.0.md")
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
if(Test-Path $Target){ 
  $t = Get-Content -Raw -LiteralPath $Target
  if($t -notmatch '\bBeing\s+Noname\b'){ $t = $t + "`n`nBeing Noname"; Set-Content -LiteralPath $Target -Value $t -Encoding UTF8 }
  git add -- $Target 2>$null
  if(git diff --cached --name-only){ git commit -m "bn(sync): update canonical 'Being Noname'" }
}
