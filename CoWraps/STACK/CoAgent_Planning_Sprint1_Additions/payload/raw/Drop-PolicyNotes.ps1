param()
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
. (Join-Path $root 'Join-CoAgent.ps1') | Out-Null

function _writeNote([string]$sid,[string]$text){
  $inbox = Join-Path (Join-Path $root ("sessions\{0}" -f $sid)) 'inbox'
  if (-not (Test-Path $inbox)) { New-Item -ItemType Directory -Force -Path $inbox | Out-Null }
  $name = "NOTE_{0}_{1}.md" -f (Get-Date -Format 'yyyyMMdd-HHmmss'), $sid
  Set-Content -LiteralPath (Join-Path $inbox $name) -Encoding UTF8 -Value $text
}

$txt = @"
Watcher policy — centralized (pre-CoAgent)
Status: $(Get-Date -Format o)

We enforce ONE watcher per session:
- co-planning  → CoQueueWatcher-co-planning
- co-migrate   → CoQueueWatcher-co-migrate

Use Drop-CoDO / Send-CoNote to coordinate.
Migrate focus: ccts fallback remediation.
"@

try {
  . (Join-Path $root 'common\NoteBridge.ps1') | Out-Null
  Send-CoNote -ToSessionId 'co-planning' -Text $txt
  Send-CoNote -ToSessionId 'co-migrate'  -Text $txt
} catch {
  _writeNote 'co-planning' $txt
  _writeNote 'co-migrate'  $txt
}
