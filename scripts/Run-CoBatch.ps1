[CmdletBinding()]
param(
  [string]$Manifest = "$PSScriptRoot\batch.manifest.json",
  [int]$MaxParallel = 8,
  [int]$DefaultTimeoutSec = 900,
  [string]$SessionId = "coagent-2025w42-sLead",
  [string]$CycleId = (Get-Date -Format "yyyyMMdd-HHmmss")
)
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest

function Has-Prop { param($o,[string]$p)
  $o -and ($o.PSObject.Properties.Match($p).Count -gt 0)
}
# repo root is parent of scripts\
$repoRoot = Split-Path -Parent $PSScriptRoot
$work = Join-Path $repoRoot ".work\$CycleId"; New-Item -Force -ItemType Directory $work | Out-Null
$locks = Join-Path $work "locks"; New-Item -Force -ItemType Directory $locks | Out-Null
$logs  = Join-Path $work "logs";  New-Item -Force -ItemType Directory $logs  | Out-Null

if (!(Test-Path $Manifest)) { throw "Manifest not found: $Manifest" }
$cfg = Get-Content $Manifest -Raw | ConvertFrom-Json

function Get-JsonProp { param($o,[string]$name,$default)
  if($o -and $o.PSObject.Properties.Match($name).Count){ $o.$name } else { $default }
}

$tasks = @()
$null = foreach($t in $cfg.tasks){
  $tasks += [pscustomobject]@{
    name    = $t.name
    script  = $t.script
    args    = (Get-JsonProp $t 'args'    @())
    cwd     = (Get-JsonProp $t 'cwd'     $repoRoot)
    env     = (Get-JsonProp $t 'env'     @{})
    mutex   = (Get-JsonProp $t 'mutex'   $null)
    timeout = (Get-JsonProp $t 'timeout' $DefaultTimeoutSec)
    needs   = (Get-JsonProp $t 'needs'   @())
    status  = 'queued'
    log     = Join-Path $logs ("{0}.log" -f $t.name.Replace(':','_'))
  }
}

function Get-Ready {
  param($all)
  $all | Where-Object {
    $_.status -eq 'queued' -and (
      -not $_.needs -or
      (@($_.needs | ForEach-Object { ($all | Where-Object name -eq $_).status }) -notcontains 'queued' -and
       @($_.needs | ForEach-Object { ($all | Where-Object name -eq $_).status }) -notcontains 'running')
    )
  }
}

function Enter-Mutex { param($name)
  if([string]::IsNullOrWhiteSpace($name)){ return $null }
  $m = New-Object System.Threading.Mutex($false, "Global\CoSuite.$name")
  if(-not $m.WaitOne([TimeSpan]::FromMinutes(30))){ throw "Mutex timeout: $name" }
  $m
}
function Exit-Mutex { param($m) if($m){ $m.ReleaseMutex(); $m.Dispose() } }

$running = @()
while(@($tasks | Where-Object status -in 'queued','running').Count -gt 0 ){
  $null = foreach($t in @((Get-Ready $tasks))){
    if((@($running)).Count -ge $MaxParallel){ break }
    $t.status='running'
    $job = Start-ThreadJob -ScriptBlock {
      param($t,$work)
      $ErrorActionPreference='Stop'
      $env:CoEmit='external'
      $m = $null
      try{
        if($t.mutex){ $m = & ${function:Enter-Mutex} $t.mutex }
        if($t.cwd){
  if([System.IO.Path]::IsPathRooted($t.cwd)){
    $wd = $t.cwd
  } else {
    $wd = Join-Path $using:repoRoot $t.cwd
  }
} else {
  $wd = Join-Path $work ("task_"+$t.name.Replace(':','_'))
}
        New-Item -Force -ItemType Directory $wd | Out-Null
        Push-Location $wd
        if ($t.env) {
  $null = foreach($p in @($t.env.PSObject.Properties)) {
    [Environment]::SetEnvironmentVariable($p.Name, [string]$p.Value)
  }
}
        $deadline = [DateTime]::UtcNow.AddSeconds([int]$t.timeout)
        $cmd = if($t.args){ "& `"$($t.script)`" $($t.args -join ' ')" } else { "& `"$($t.script)`"" }
        $out = & pwsh -NoProfile -Command $cmd 2>&1
        if([DateTime]::UtcNow -gt $deadline){ throw "timeout ($($t.timeout)s)" }
        Pop-Location
        [pscustomobject]@{ ok=$true; task=$t.name; output=$out -join [Environment]::NewLine }
      } catch {
        [pscustomobject]@{ ok=$false; task=$t.name; output=$_ | Out-String }
      } finally { if($m){ & ${function:Exit-Mutex} $m } }
    } -ArgumentList $t,$work
    $null = $null = ($running += [pscustomobject]@{ name=$t.name; job=$job })
  }

  $null = foreach($r in @($running)){
    if($r.job.State -in 'Completed','Failed','Stopped'){
      $res = Receive-Job -Job $r.job -ErrorAction SilentlyContinue
      $task = $tasks | Where-Object name -eq $r.name
      $task.status = ((Has-Prop $res 'ok') -and $res.ok) ? 'ok' : 'fail'
      $logText = (Has-Prop $res 'output') ? $res.output : ($res | Out-String); $logText | Set-Content -Encoding UTF8 $task.log
@($running | Where-Object name -ne $r.name)
    }
  }
  Start-Sleep -Milliseconds 120
}

$ok   = @($tasks | Where-Object status -eq 'ok').Count
$fail = @($tasks | Where-Object status -eq 'fail').Count
$repo = Split-Path $repoRoot -Leaf
$sha  = (git -C $repoRoot rev-parse --short HEAD)
$br   = (git -C $repoRoot rev-parse --abbrev-ref HEAD)
$L1 = "parallel: $ok ok, $fail fail (max=$MaxParallel, cycle=$CycleId)"
$L2 = "logs: $logs  manifest: $Manifest"

$emit = Join-Path $repoRoot 'scripts/Emit-OneLineReceipt.ps1'
if(Test-Path $emit){
  pwsh -NoProfile -File $emit `
    -SessionId $SessionId -CycleId $CycleId -Attempt 1 -Status $(if($fail){'partial'}else{'ready'}) `
    -RepoName $repo -Branch $br -Prev '-' -NewSha $sha -LinesUp $L1 -LinesDown $L2
} else {
  # Plain fallback (BPOE) if emitter isn’t present / ANSI not supported
  $compact = "# CoPONG: session_id=$SessionId cycle_id=$CycleId attempt=1 status=$(if($fail){'partial'}else{'ready'}) remote=pushed commit_prev=- commit_new=$sha repo=$repo branch=$br $L1 $L2"
  try { Set-Clipboard -Value $compact -ErrorAction SilentlyContinue } catch {}
  $esc=[char]27; $supports = ($Host.Name -ne 'ConsoleHost') -or ($PSStyle.OutputRendering -ne 'PlainText')
  $on  = $supports ? "$esc[38;5;135m" : ''
  $off = $supports ? "$esc[0m"       : ''
  $bar = ($supports ? "$esc[38;5;135m" : '') + ('=' * [Math]::Max(80, $compact.Length)) + ($supports ? "$esc[0m" : '')

}






















