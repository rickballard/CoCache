param(
  [string]$SessionName = "Productize backchatter"
)

$desktop = [Environment]::GetFolderPath('Desktop')
$wt      = Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps\wt.exe'     # Windows Terminal
$pwsh    = (Get-Command pwsh).Source                                      # PowerShell 7
$pair    = Join-Path $HOME 'Documents\GitHub\CoAgent\tools\Pair-CoSession.ps1'

# Icons (in this folder)
$thisDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$icoFace = Join-Path $thisDir 'CatFace.ico'
$icoPaw  = Join-Path $thisDir 'CatPaw.ico'
$icoEye  = Join-Path $thisDir 'CatEye.ico'

# Ensure Electron build.icon points to our app icon
$pkg = Join-Path $HOME 'Documents\GitHub\CoAgent\electron\package.json'
if (Test-Path $pkg) {
  try {
    $j = Get-Content $pkg -Raw | ConvertFrom-Json
    if (-not $j.PSObject.Properties.Match('build')) { $j | Add-Member build (@{}) }
    $j.build.icon = "build/icon.ico"
    ($j | ConvertTo-Json -Depth 10) | Set-Content $pkg -Encoding UTF8
    Write-Host "Set build.icon = build/icon.ico in electron/package.json"
  } catch {}
}

function New-Shortcut {
  param(
    [Parameter(Mandatory)][string]$Path,
    [Parameter(Mandatory)][string]$Target,
    [string]$Args = '',
    [string]$WorkingDir = $HOME,
    [string]$IconLocation = $null   # "C:\path\app.ico" or "C:\path\app.exe,0"
  )
  $shell = New-Object -ComObject WScript.Shell
  $sc = $shell.CreateShortcut($Path)
  $sc.TargetPath = $Target
  $sc.Arguments  = $Args
  $sc.WorkingDirectory = $WorkingDir
  if ($IconLocation) { $sc.IconLocation = $IconLocation }
  $sc.Save()
}

# 1) PowerShell 7 (Tabs) — icon: Paw
$lnk1 = Join-Path $desktop 'PowerShell 7 (Tabs).lnk'
if (Test-Path $wt) {
  New-Shortcut -Path $lnk1 -Target $wt -Args '-w 0 nt -p "PowerShell"' -IconLocation $icoPaw
} else {
  New-Shortcut -Path $lnk1 -Target $pwsh -Args '-NoLogo' -IconLocation $icoPaw
}

# 2) CoAgent Panel (PS7 Tabs) — icon: Cat Face
$lnk2 = Join-Path $desktop 'CoAgent Panel (PS7 Tabs).lnk'
if (Test-Path $wt) {
  $psCmd = '$env:COAGENT_SESSION="{0}"; & "{1}"' -f $SessionName, $pair
  $args2 = '-w 0 nt -d "~" pwsh -NoLogo -NoExit -Command "{0}"' -f ($psCmd.Replace('"','\"'))
  New-Shortcut -Path $lnk2 -Target $wt -Args $args2 -IconLocation $icoFace
} else {
  $args2 = '-NoLogo -NoExit -Command "$env:COAGENT_SESSION='''+$SessionName+'''; & '''+$pair+'''"'
  New-Shortcut -Path $lnk2 -Target $pwsh -Args $args2 -IconLocation $icoFace
}

# 3) Dev Terminal – PS7 + CoAgent (two tabs) — icon: Cat Eye
$lnk3 = Join-Path $desktop 'Dev Terminal – PS7 + CoAgent.lnk'
if (Test-Path $wt) {
  $psCmd = '$env:COAGENT_SESSION="{0}"; & "{1}"' -f $SessionName, $pair
  $args3 = @(
    '-w 0'
    'nt -p "PowerShell"'
    ('nt -d "~" pwsh -NoLogo -NoExit -Command "{0}"' -f ($psCmd.Replace('"','\"')))
  ) -join ' ; '
  New-Shortcut -Path $lnk3 -Target $wt -Args $args3 -IconLocation $icoEye
} else {
  $cmdPath = Join-Path $HOME 'Documents\GitHub\CoAgent\tools\CoAgentTwoTabs.cmd'
  @"
@echo off
start "" "" "$pwsh" -NoLogo
start "" "" "$pwsh" -NoLogo -NoExit -Command "$env:COAGENT_SESSION='$SessionName'; & '$pair'"
"@ | Set-Content -Encoding ASCII $cmdPath
  New-Shortcut -Path $lnk3 -Target $cmdPath -IconLocation $icoEye
}

Write-Host @"
Shortcuts created on your Desktop:
 - $lnk1
 - $lnk2
 - $lnk3

Rebuild Electron to apply the app icon, e.g.:
  pushd "$HOME\Documents\GitHub\CoAgent\electron"; npx electron-builder -w dir ; popd
"@
