param([string]$CoProfilePath="$env:USERPROFILE\Documents\CoProfile\coprofile.json",[string]$OutDir="$HOME\Downloads\CoTemp\policy")
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
if(-not(Test-Path $CoProfilePath)){throw "CoProfile not found: $CoProfilePath"}
if(-not(Test-Path $OutDir)){New-Item -ItemType Directory -Force -Path $OutDir|Out-Null}
$cfg=Get-Content $CoProfilePath -Raw|ConvertFrom-Json
foreach($k in 'tokens','secrets','pat','pats','apiKeys','auth','credentials'){ if($cfg.PSObject.Properties.Name -contains $k){$cfg.$k=$null} }
$policy=[pscustomobject]@{type='CoProfile.PolicyCapsule';source_path=$CoProfilePath;default_tag=$cfg.defaultTag??'gmig';default_session=$cfg.defaultSession??'co-migrate';bpoe=$cfg.bpoe;rules=$cfg.rules;prompts=$cfg.prompts;preferences=$cfg.preferences;note='Non-secret subset. Paste as session bootstrap.'}
$json=$policy|ConvertTo-Json -Depth 12
$path=Join-Path $OutDir 'PolicyCapsule.json'; $md= "```json`n$json`n```"; $mdPath=Join-Path $OutDir 'PolicyCapsule.paste.md'
$json|Out-File -Enc utf8 $path; $md|Out-File -Enc utf8 $mdPath
try{Set-Clipboard -Value $md}catch{}; Write-Host "Policy Capsule ready:`n JSON: $path`n Paste: $mdPath"
