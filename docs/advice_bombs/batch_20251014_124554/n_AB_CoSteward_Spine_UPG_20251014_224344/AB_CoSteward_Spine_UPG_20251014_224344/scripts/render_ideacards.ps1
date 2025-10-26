# Render a simple IdeaCards view from mined notes
$mined = Join-Path $PSScriptRoot "..\sandbox\mined"
$cards = Join-Path $PSScriptRoot "..\sandbox\IdeaCards.md"
$items = Get-ChildItem $mined -Filter *.md -File -Recurse
$content = "# IdeaCards`n`n"
foreach($i in $items){
  $content += "## " + $i.BaseName + "`n`n"
  $content += (Get-Content $i.FullName -Raw) + "`n`n---`n"
}
Set-Content $cards $content -Encoding UTF8
Write-Host "Wrote $cards"

