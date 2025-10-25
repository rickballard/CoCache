# PowerShell snippets used in the session (curated).

function Test-GitBigBlobsRepo([string]$Repo,[long]$LimitBytes=100MB){
  if(!(Test-Path (Join-Path $Repo '.git'))){ throw "Not a git repo: $Repo" }
  $map=@{}
  foreach($row in (git -C $Repo rev-list --objects --all)){
    $p=$row -split ' '
    if($p[0] -and -not $map.ContainsKey($p[0])){ $map[$p[0]] = ($p.Count -gt 1 ? ($p[1..($p.Count-1)] -join ' ') : '') }
  }
  if($map.Count -eq 0){ return @() }
  $psi=[System.Diagnostics.ProcessStartInfo]::new()
  $psi.FileName='git'; $psi.Arguments="-C `"$Repo`" cat-file --batch-check"
  $psi.UseShellExecute=$false; $psi.RedirectStandardInput=$true; $psi.RedirectStandardOutput=$true
  $p=[System.Diagnostics.Process]::Start($psi)
  $p.StandardInput.Write((($map.Keys)-join"`n")+"`n"); $p.StandardInput.Close()
  $out=$p.StandardOutput.ReadToEnd(); $p.WaitForExit()
  $hits=@()
  foreach($line in ($out -split "`n")){
    if(!$line){continue}
    $f=$line -split '\s+'
    if($f.Count -ge 3 -and $f[1] -eq 'blob'){
      $size=[int64]$f[2]
      if($size -ge $LimitBytes){ $hits += [pscustomobject]@{ sha=$f[0]; MB=[math]::Round($size/1MB,2); path=$map[$f[0]] } }
    }
  }
  $hits | Sort-Object MB -Descending
}

function Start-CoTempHandoffWatcher {
  param([string]$Session = ($env:COAGENT_SESSION ?? 'adhoc'))
  $base = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'CoTemp'
  foreach($sub in @("$Session\handoffs\GrandMigration-CoAgent", "$Session\handoffs\CoAgent-Productization")){
    $path = Join-Path $base $sub
    if(!(Test-Path $path)){ New-Item -ItemType Directory -Force -Path $path | Out-Null }
    $fsw = New-Object IO.FileSystemWatcher $path, '*.md'
    $fsw.EnableRaisingEvents = $true
    Register-ObjectEvent -InputObject $fsw -EventName Created -SourceIdentifier "CoTempHandoffCreated_$sub" -MessageData $sub -Action {
      $file = $Event.SourceEventArgs.FullPath
      Write-Host "[CoTemp] New handoff in $($Event.MessageData): $file" -ForegroundColor Cyan
    } | Out-Null
  }
  Write-Host "Watching CoTemp handoffs under $base for session '$Session'…" -ForegroundColor Green
}
