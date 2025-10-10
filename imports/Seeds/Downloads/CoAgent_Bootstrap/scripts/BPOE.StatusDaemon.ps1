param([int]$IntervalSec=90,[string]$OutFile="$HOME\Downloads\CoTemp\logs\BPOE.status.txt",[string]$Focus='Migration',[string]$RepoPath="$HOME\Documents\GitHub\CoCivium",[string]$Branch='')
$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
$dir=Split-Path $OutFile -Parent; if(-not(Test-Path $dir)){New-Item -ItemType Directory -Force -Path $dir|Out-Null}
while($true){
  $t=(Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'); $b=$Branch
  if(-not $b -and (Test-Path $RepoPath)){Push-Location $RepoPath; try{$b=(git rev-parse --abbrev-ref HEAD)2>$null}finally{Pop-Location}}
  $line="[BPOE] t=$t | focus=$Focus | repo=$(Split-Path -Leaf $RepoPath)@$b | health=OK"
  $line|Tee-Object -FilePath $OutFile -Append; Start-Sleep -Seconds $IntervalSec
}
