
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null
try { . (Join-Path $root 'common\NoteBridge.ps1') | Out-Null } catch {}

$textP = "Planning: central watcher active; please don't start another. Coordinate via Drop-CoDO / Send-CoNote. (Migrate continues ccts fallback.)"
$textM = "Migrate: central watcher active; please don't start another. Keep ccts fallback going. Use Drop-CoDO / Send-CoNote to coordinate."
Send-CoNote -ToSessionId 'co-planning' -Text $textP
Send-CoNote -ToSessionId 'co-migrate'  -Text $textM
"Sent."
