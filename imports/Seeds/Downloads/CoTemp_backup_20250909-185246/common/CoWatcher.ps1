Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
if (-not (Get-Command Test-DOHeader -ErrorAction SilentlyContinue)) {
  function Test-DOHeader {
    param([Parameter(Mandatory)][string]$Path)
    $t = Get-Content -Raw -LiteralPath $Path
    $m = [regex]::Match($t, '<#\s*---\s*(?<yaml>[\s\S]*?)\s*---\s*#>')
    if (-not $m.Success) { Write-Warning "No header: $Path"; return $false }
    $y = $m.Groups['yaml'].Value
    foreach($k in 'title','repo','risk','consent'){ if ($y -notmatch "(?m)^\s*$k\s*:") { Write-Warning "Missing: $k"; return $false } }
    return $true
  }
}
function Wait-ForStableFile {
  [CmdletBinding()]
  param([Parameter(Mandatory)][string]$Path,[int]$IntervalMs=300,[int]$Consecutive=3,[int]$TimeoutSeconds=60)
  $last=$null;$ok=0;$sw=[Diagnostics.Stopwatch]::StartNew()
  while($sw.Elapsed.TotalSeconds -lt $TimeoutSeconds){
    if (Test-Path -LiteralPath $Path) {
      $len=(Get-Item -LiteralPath $Path).Length
      $hash=(Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
      $cur="$len`:$hash"
      if ($cur -eq $last){$ok++} else {$ok=0;$last=$cur}
      if ($ok -ge $Consecutive){return $true}
    } else {$ok=0}
    Start-Sleep -Milliseconds $IntervalMs
  }
  return $false
}
function Start-CoQueueWatcher {
  [CmdletBinding()]
  param([int]$PollMs=600,[switch]$Loop)
  if (-not $script:SessionRoot) {
    $script:CoRoot = Join-Path $HOME 'Downloads\CoTemp'
    if (-not $env:COSESSION_ID) { $env:COSESSION_ID = "co-$PID-$(Get-Date -Format 'yyyyMMdd-HHmmss')" }
    $script:SessionRoot = Join-Path $script:CoRoot ("sessions\{0}" -f $env:COSESSION_ID)
    $script:Inbox  = Join-Path $script:SessionRoot 'inbox'
    $script:Outbox = Join-Path $script:SessionRoot 'outbox'
    $script:Logs   = Join-Path $script:SessionRoot 'logs'
  }
  $null = New-Item -ItemType Directory -Force -Path $script:Inbox,$script:Outbox,$script:Logs | Out-Null
  Write-Host ("Watcher session: {0}" -f $env:COSESSION_ID) -ForegroundColor Cyan
  do {
    $items = Get-ChildItem -LiteralPath $script:Inbox -Filter '*.ps1' -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime
    foreach($it in $items){
      $path = $it.FullName
      if (-not (Wait-ForStableFile -Path $path)) { continue }
      if (-not (Test-DOHeader -Path $path)) {
        Write-Warning ("Header check failed: {0}" -f $it.Name)
        Move-Item -LiteralPath $path -Destination (Join-Path $script:Outbox ("rejected-{0}" -f $it.Name)) -Force
        continue
      }
      $runId = "$(Get-Date -Format 'yyyyMMdd-HHmmss')-$PID"
      $base  = [IO.Path]::GetFileNameWithoutExtension($path)
      $logTxt= Join-Path $script:Logs  ("{0}-{1}.txt"  -f $base,$runId)
      $logJs = Join-Path $script:Logs  ("{0}-{1}.json" -f $base,$runId)
      $dest  = Join-Path $script:Outbox("{0}-{1}.ps1"  -f $base,$runId)
      $t0=Get-Date; $result='fail'; $out=''
      try { $out = & $path 2>&1 | Out-String; $result='pass' } catch { $out = ($_ | Out-String) }
      finally {
        $elapsed = [int]((Get-Date)-$t0).TotalMilliseconds
        $out | Set-Content -LiteralPath $logTxt -Encoding UTF8
        $type = if ($result -eq 'pass') { 'info' } else { 'error' }
        $evt = [pscustomobject]@{
          ts=(Get-Date).ToString('o'); session_id=$env:COSESSION_ID; do_title=$base; repo_path=""
          risk=@{writes=$false;network=$false;secrets=$false;destructive=$false}
          consent_effective=@{allow_writes=[bool]$env:COAGENT_ALLOW_WRITES;allow_network=[bool]$env:COAGENT_ALLOW_NETWORK}
          events=@(@{ts=(Get-Date).ToString('o');type=$type;op='run';msg='completed';elapsed_ms=$elapsed})
          result=$result
        }
        $evt | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $logJs -Encoding UTF8
      }
      Move-Item -LiteralPath $path -Destination $dest -Force
      Write-Host ("Processed {0} -> {1}" -f $it.Name,(Split-Path -Leaf $dest)) -ForegroundColor Green
    }
    if (-not $Loop) { break }
    Start-Sleep -Milliseconds $PollMs
  } while ($true)
}
function Start-CoQueueWatcherJob {
  [CmdletBinding()] param([int]$PollMs=600,[string]$SessionId,[string]$PanelName)
  Start-Job -Name ("CoQueueWatcher-{0}" -f $SessionId) -ScriptBlock {
    param($sid,$pname)
    Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
    $env:COSESSION_ID = $sid
    . (Join-Path $env:USERPROFILE 'Downloads\CoTemp\Join-CoAgent.ps1')
    try { Register-CoPanel -Name $pname -SessionId $sid | Out-Null } catch {}
    Start-CoQueueWatcher -Loop -PollMs 600
  } -ArgumentList $SessionId,$PanelName | Out-Null
  Write-Host ("Watcher job started: {0}" -f $SessionId) -ForegroundColor Cyan
}
