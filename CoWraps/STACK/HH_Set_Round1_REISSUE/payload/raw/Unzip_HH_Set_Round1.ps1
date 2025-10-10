Set-StrictMode -Version Latest
$ZipPath = "$env:USERPROFILE\Downloads\HH_Set_Round1_REISSUE.zip"
$ExtractTo = $env:USERPROFILE\Downloads\HH_Set_Round1_REISSUE\
Expand-Archive -LiteralPath $ZipPath -DestinationPath $ExtractTo -Force
Write-Host "✅ Extraction complete: $ExtractTo"
