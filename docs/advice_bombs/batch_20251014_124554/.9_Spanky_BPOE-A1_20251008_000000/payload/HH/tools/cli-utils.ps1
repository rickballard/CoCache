param([string]$Repo)
function Resolve-GitRoot([string]$hint){
  try{ $start = if($hint){ $hint } else { (Get-Location).Path }
       Push-Location $start; $root = (& git rev-parse --show-toplevel 2>$null); Pop-Location
       if($LASTEXITCODE -eq 0 -and $root){ return $root } } catch {}
  return $null
}
function Write-ProgressEcho{ param([string]$Phase,[string]$Detail="")
  $ts = (Get-Date).ToString("HH:mm:ss"); Write-Host ("[{0}] {1,-10} {2}" -f $ts,$Phase,$Detail)
}
function Invoke-WithSpinner {
  [CmdletBinding()]
  param([Parameter(Mandatory)][scriptblock]$ScriptBlock,[string]$Label="Working",[int]$PulseMs=200)
  $frames = @('|','/','-','\'); $i=0; $start=Get-Date
  $job=Start-Job -ScriptBlock $ScriptBlock
  while($job.State -eq 'Running'){
    $secs=[int]((Get-Date)-$start).TotalSeconds; $f=$frames[$i%$frames.Count]
    Write-Host ("{0} {1,2}s {2}" -f $Label,$secs,$f) -NoNewline
    Start-Sleep -Milliseconds $PulseMs; Write-Host "`r" -NoNewline; $i++
  }
  Receive-Job $job -Wait -AutoRemoveJob
}
function Git-Push-Spun { param([string]$Repo)
  $root=Resolve-GitRoot $Repo; if(-not $root){throw "Not in a git repo and no -Repo given."}
  Push-Location $root; Write-ProgressEcho "git" "push → $(Split-Path $root -Leaf)"
  Invoke-WithSpinner { git push } -Label "Pushing"; Pop-Location; Write-ProgressEcho "done" "push complete"
}
function Git-Pull-Spun { param([string]$Repo)
  $root=Resolve-GitRoot $Repo; if(-not $root){throw "Not in a git repo and no -Repo given."}
  Push-Location $root; Write-ProgressEcho "git" "pull --rebase ← $(Split-Path $root -Leaf)"
  Invoke-WithSpinner { git pull --rebase } -Label "Pulling"; Pop-Location; Write-ProgressEcho "done" "pull complete"
}