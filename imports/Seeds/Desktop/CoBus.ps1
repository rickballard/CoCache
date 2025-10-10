# CoBus.ps1 — v0.4 (DPAPI-cached token; no secrets stored in repo)
param()

function Get-CoBusTokenCached {
  $file = Join-Path $env:LOCALAPPDATA 'CoBus\token.clixml'
  if(Test-Path $file){
    try { return (Import-Clixml $file).GetNetworkCredential().Password } catch { return $null }
  }
  return $null
}
function Set-CoBusTokenCached([Parameter(Mandatory)][string]$Token){
  $dir = Join-Path $env:LOCALAPPDATA 'CoBus'; New-Item -ItemType Directory -Force -Path $dir | Out-Null
  $sec  = ConvertTo-SecureString $Token -AsPlainText -Force
  $cred = New-Object System.Management.Automation.PSCredential ('token',$sec)
  $cred | Export-Clixml -Path (Join-Path $dir 'token.clixml')
}
function Test-CoBusToken([string]$Token,[string]$Homeserver='https://matrix-client.matrix.org'){
  if(-not $Token){ return $false }
  try{
    $resp = Invoke-RestMethod -Headers @{ Authorization = "Bearer $Token" } `
            -Uri "$Homeserver/_matrix/client/v3/account/whoami" -Method Get -ErrorAction Stop
    return [bool]$resp.user_id
  } catch { return $false }
}

function New-CoBusToken {
  param([string]$Homeserver='https://matrix-client.matrix.org',[string]$UserId='@rick_ball:matrix.org')
  # Try cached token first
  $tok = Get-CoBusTokenCached
  if(Test-CoBusToken -Token $tok -Homeserver $Homeserver){ return $tok }
  # Otherwise prompt password and login
  $sec  = Read-Host 'Matrix password' -AsSecureString
  $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec)
  $pwd  = [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
  $payload = @{ type='m.login.password'; identifier=@{ type='m.id.user'; user=$UserId }; password=$pwd } | ConvertTo-Json
  try {
    $tok = (Invoke-RestMethod -Method Post -Uri "$Homeserver/_matrix/client/v3/login" -ContentType 'application/json' -Body $payload).access_token
    if($tok){ Set-CoBusTokenCached $tok }
    return $tok
  } finally {
    if($bstr){ [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) }
  }
}

function Get-CoBusLast {
  [CmdletBinding()]
  param(
    [string]$Room = '!onAbUAZZGsiexyPpza:matrix.org',
    [int]$Last = 50,
    [string]$Homeserver = 'https://matrix-client.matrix.org',
    [string]$UserId = '@rick_ball:matrix.org'
  )
  $tok = New-CoBusToken -Homeserver $Homeserver -UserId $UserId
  $roomEnc = [uri]::EscapeDataString($Room)
  $url = "$Homeserver/_matrix/client/v3/rooms/$roomEnc/messages?dir=b&limit=$Last"
  $resp = Invoke-RestMethod -Headers @{ Authorization = "Bearer $tok" } -Uri $url -Method Get
  foreach($ev in $resp.chunk){ $ev | ConvertTo-Json -Depth 6 }
}

function Add-CoBusLine {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)] [string]$Text,
    [string]$Room = '!onAbUAZZGsiexyPpza:matrix.org',
    [string]$Homeserver = 'https://matrix-client.matrix.org',
    [string]$UserId = '@rick_ball:matrix.org'
  )
  $tok = New-CoBusToken -Homeserver $Homeserver -UserId $UserId
  $roomEnc = [uri]::EscapeDataString($Room)
  $txn = [Guid]::NewGuid().ToString('n')
  $body = @{ msgtype='m.text'; body=$Text } | ConvertTo-Json
  $url = "$Homeserver/_matrix/client/v3/rooms/$roomEnc/send/m.room.message/$txn"
  Invoke-RestMethod -Headers @{ Authorization = "Bearer $tok" } -Uri $url -Method Put -ContentType 'application/json' -Body $body | Out-Null
}
