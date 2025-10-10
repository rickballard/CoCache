#requires -version 5.1
[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$To,
  [ValidateSet('handoff','status','request','bpoe_capsule','achievements','todo')]
  [string]$Type='handoff',
  [string]$From='Unknown Session',
  [string]$Body='',
  [string]$BodyFile='',
  [string[]]$Attachments=@(),
  [string]$Priority='normal',
  [string]$Base="$env:USERPROFILE\Downloads\CoTemp"
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
function Sanitize([string]$s){ if(-not $s){return 'x'} $t=$s -replace '[^A-Za-z0-9._-]+','-'; ($t -replace '-{2,}','-').Trim('-').Trim() }
$Base=[IO.Path]::GetFullPath($Base); $inboxRoot=Join-Path $Base 'inbox'; [IO.Directory]::CreateDirectory($inboxRoot)|Out-Null
if($Body -and $BodyFile){throw "Provide Body or BodyFile, not both."}
if($BodyFile){ if(-not(Test-Path $BodyFile)){throw "BodyFile not found: $BodyFile"}; $Body=Get-Content $BodyFile -Raw }
$slug=Sanitize $To; $fromS=Sanitize $From; $inbox=Join-Path $inboxRoot $slug; [IO.Directory]::CreateDirectory($inbox)|Out-Null
$id=[guid]::NewGuid().ToString(); $utcDisp=(Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'); $utcFile=(Get-Date).ToUniversalTime().ToString('yyyy-MM-dd_HHmmssZ')
$name=$utcFile+'__'+$Type+'__'+$fromS+'__to__'+$slug+'__'+$id
$msg=[pscustomobject]@{id=$id;type=$Type;from_session=$From;to_session=$To;created_utc=$utcDisp;priority=$Priority;title=("$Type from $From");body_markdown=$Body;attachments=$Attachments;ack=$false}
$msg|ConvertTo-Json -Depth 12|Out-File -Enc utf8 (Join-Path $inbox ($name+'.json'))
$paste=@"
> BACKCHAT: ($Type) from **$From** to **$To**
> ID: $id  |  Priority: $Priority  |  UTC: $utcDisp
---
$Body

(Reply with: ACK $id after acting.)
"@
$mdPath=Join-Path $inbox ($name+'.paste.md'); $paste|Out-File -Enc utf8 $mdPath; try{Set-Clipboard -Value $paste}catch{}; Write-Host "Backchat ready: $mdPath"
