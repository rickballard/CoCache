param([string]$Text)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
New-Item -ItemType Directory -Force .coagent\guardrails | Out-Null
$hit = $false
$phrases = @(
  'i want to die','suicid','kill myself',
  'hopeless','end it all',
  'i am 12','im 11','i am a kid'
)
foreach($p in $phrases){ if($Text -match $p){ $hit=$true; break } }
$breadcrumb = [ordered]@{
  ts = (Get-Date).ToString('s')
  matched = $hit
  sample = if($Text){ $Text.Substring(0,[Math]::Min(80,$Text.Length)) } else { "" }
}
($breadcrumb | ConvertTo-Json -Depth 6) + "`n" | Add-Content .coagent\guardrails\redirects.jsonl
if($hit){ Write-Host "AT-RISK → redirect recommended"; exit 2 } else { Write-Host "OK"; exit 0 }
