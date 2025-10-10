
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = (Resolve-Path (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "..")).Path
$logDir = Join-Path $root ".coagent\logs"
if(!(Test-Path $logDir)){ Write-Host "ℹ️ No logs at $logDir"; exit 0 }

$stats = @{
  files = 0; lines = 0; users = @{}; intents = @{}; errors = 0; sessions = @{};
}
Get-ChildItem $logDir -Filter *.jsonl -Recurse | ForEach-Object {
  $stats.files++
  Get-Content $_.FullName | ForEach-Object {
    if([string]::IsNullOrWhiteSpace($_)){ return }
    try{ $j = $_ | ConvertFrom-Json } catch { $stats.errors++; return }
    $stats.lines++
    if($j.user){
      $u = [string]$j.user
      $stats.users[$u] = 1 + ($(if($stats.users.ContainsKey($u)){ $stats.users[$u] } else { 0 }))
    }
    if($j.intent){
      $i = [string]$j.intent
      $stats.intents[$i] = 1 + ($(if($stats.intents.ContainsKey($i)){ $stats.intents[$i] } else { 0 }))
    }
    if($j.session_id){
      $s = [string]$j.session_id
      $stats.sessions[$s] = 1 + ($(if($stats.sessions.ContainsKey($s)){ $stats.sessions[$s] } else { 0 }))
    }
  }
}

"---- BPOE Snapshot ----"
"files:   {0}" -f $stats.files
"lines:   {0}" -f $stats.lines
"users:   {0}" -f $($stats.users.Keys.Count)
"intents: {0}" -f $($stats.intents.Keys.Count)
"errors:  {0}" -f $stats.errors
if($stats.users.Keys.Count){ "top users:    " + ($stats.users.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 5 | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join ", " }
if($stats.intents.Keys.Count){ "top intents:  " + ($stats.intents.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 5 | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join ", " }
if($stats.sessions.Keys.Count){ "top sessions: " + ($stats.sessions.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 5 | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join ", " }
"-----------------------"
