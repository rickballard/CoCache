param([Parameter(Mandatory)][string]$Text)
$CT = Join-Path $env:USERPROFILE "Downloads\CoTemp"
$IdDir = Join-Path $CT "identity"
New-Item -ItemType Directory -Force -Path $IdDir | Out-Null

$keyFile = Join-Path $IdDir "civid.key"
if (!(Test-Path $keyFile)) {
  [IO.File]::WriteAllBytes($keyFile, (1..32 | ForEach-Object { Get-Random -Max 256 }))
}
$cividFile = Join-Path $IdDir "civid.json"
if (!(Test-Path $cividFile)) {
  $seed = ([guid]::NewGuid().ToString('N')).Substring(0,12)
  $traits = ($seed.ToCharArray() | Select-Object -First 8) -join ''
  $cid = [ordered]@{
    schema      = 'civ.id.v1'
    civId       = ("civ-{0}" -f $seed)
    avatarCode  = $traits
    created     = (Get-Date).ToUniversalTime().ToString('o')
    storageHint = $IdDir
  }
  $cid | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 $cividFile
}
$key = [IO.File]::ReadAllBytes($keyFile)
$cid = Get-Content $cividFile | ConvertFrom-Json
$h = New-Object System.Security.Cryptography.HMACSHA256 ($key)
$sig = ($h.ComputeHash([Text.Encoding]::UTF8.GetBytes($Text)) | ForEach-Object { $_.ToString("x2") }) -join ''
[pscustomobject]@{ civId = $cid.civId; avatarCode = $cid.avatarCode; sig = $sig }
