# ScripTagger Demo — resilient PS7 bootstrap (Windows)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$Repo='rickballard/MeritRank'
$Base="https://github.com/$Repo/releases/latest/download"
$Zip='scripttagger-demo-windows-x64.zip'
$Tmp=Join-Path $env:TEMP 'stg-run'
Remove-Item $Tmp -Recurse -Force -ErrorAction SilentlyContinue; New-Item -ItemType Directory $Tmp | Out-Null

# Quick HEAD check
try { $resp = Invoke-WebRequest "$Base/$Zip" -Method Head -UseBasicParsing -TimeoutSec 10 } catch { $resp = $null }
if (-not $resp -or $resp.StatusCode -ne 200) {
  Write-Host "No portable build found yet. Launching the hosted demo…" -ForegroundColor Yellow
  $url = 'https://opename.org/docs/scripttagger/demo.html'
  $edge = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
  if (Test-Path $edge) { Start-Process $edge "--app=$url" } else { Start-Process $url }
  exit
}

# Download + verify
Invoke-WebRequest "$Base/$Zip"          -OutFile (Join-Path $Tmp $Zip)
Invoke-WebRequest "$Base/checksums.txt" -OutFile (Join-Path $Tmp 'checksums.txt')
$shaLine = (Get-Content (Join-Path $Tmp 'checksums.txt')) | Where-Object { $_ -match "\b$([regex]::Escape($Zip))$" }
if (-not $shaLine) { throw "No checksum entry for $Zip" }
$expected = ($shaLine -split '\s+')[0].ToLower()
$actual   = (Get-FileHash (Join-Path $Tmp $Zip) -Algorithm SHA256).Hash.ToLower()
if ($expected -ne $actual) { throw "Checksum mismatch.`nexpected=$expected`nactual  =$actual" }

# Unzip & launch (zip contains scripttagger.cmd that opens the hosted demo in an app window)
$AppDir = Join-Path $Tmp 'app'
Expand-Archive (Join-Path $Tmp $Zip) -DestinationPath $AppDir -Force
$Launcher = Join-Path $AppDir 'scripttagger.cmd'
Unblock-File $Launcher; & $Launcher

