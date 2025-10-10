# Join-CoAgent.ps1
param([string]$SessionId = $(if ($env:COSESSION_ID) { $env:COSESSION_ID } else { "co-$($PID)-$(Get-Date -Format 'yyyyMMdd-HHmmss')" }))
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
. "$PSScriptRoot\CoTemp.Bootstrap.ps1"

$script:CoRoot      = Join-Path $HOME 'Downloads\CoTemp'
$script:SessionRoot = Join-Path $script:CoRoot ("sessions\{0}" -f $SessionId)
$script:Inbox       = Join-Path $script:SessionRoot 'inbox'
$script:Logs        = Join-Path $script:SessionRoot 'logs'
$null = New-Item -ItemType Directory -Force -Path $script:CoRoot,$script:SessionRoot,$script:Inbox,$script:Logs | Out-Null
$env:COSESSION_ID = $SessionId

function CoTemp { param([string]$Rel) if ($Rel) { Join-Path $script:CoRoot $Rel } else { $script:CoRoot } }

function Wait-ForStableFile {
  param([string]$Path,[int]$IntervalMs=400,[int]$Consecutive=4,[int]$TimeoutSeconds=120)
  $last=$null;$stable=0;$sw=[Diagnostics.Stopwatch]::StartNew()
  while($sw.Elapsed.TotalSeconds -lt $TimeoutSeconds){
    if(Test-Path -LiteralPath $Path){
      $len=(Get-Item -LiteralPath $Path).Length
      $hash=(Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
      $cur="$len`:$hash"
      if($cur -eq $last){$stable++}else{$stable=0;$last=$cur}
      if($stable -ge $Consecutive){$sw.Stop();return $true}
    } else {$stable=0}
    Start-Sleep -Milliseconds $IntervalMs
  }
  $sw.Stop();return $false
}

function Test-DOHeader {
  param([string]$Path)
  $t=Get-Content -Raw -LiteralPath $Path
  $m=[regex]::Match($t,'<#\s*---\s*(?<yaml>[\s\S]*?)\s*---\s*#>')
  if(-not $m.Success){Write-Error 'Missing commented YAML header block <# --- ... --- #>.';return $false}
  if(($t.Substring($m.Index+$m.Length)) -notmatch '(?m)^\s*#\s*\[PASTE IN POWERSHELL\]\s*$'){Write-Warning "Body missing '# [PASTE IN POWERSHELL]' marker."}
  return $true
}

function Start-CoQueueWatcher {
  param([int]$PollMs=600,[switch]$Once)
  do{
    $items=Get-ChildItem -LiteralPath $script:Inbox -Filter '*.ps1' -File -EA SilentlyContinue | Sort-Object LastWriteTime
    foreach($it in $items){
      $path=$it.FullName
      if(-not (Wait-ForStableFile -Path $path)){continue}
      if(-not (Test-DOHeader -Path $path)){continue}
      $out=& $path 2>&1 | Out-String
      $log=Join-Path $script:Logs ("{0}-{1}.txt" -f [IO.Path]::GetFileNameWithoutExtension($path),(Get-Date -Format 'yyyyMMdd-HHmmss'))
      $out | Set-Content -LiteralPath $log -Encoding UTF8
      Move-Item -LiteralPath $path -Destination ($path + '.done') -Force
      Write-Host ("Processed {0}" -f $it.Name) -ForegroundColor Green
    }
    if($Once){break}
    Start-Sleep -Milliseconds $PollMs
  } while($true)
}

Write-Host ("Joined CoAgent session: {0}" -f $env:COSESSION_ID) -ForegroundColor Cyan
