Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$script:BPOE_Current = $null
function Start-BPOE {
  [CmdletBinding()]param([Parameter(Mandatory)][string]$Id,[Parameter(Mandatory)][string]$Title,[string]$Tags="do")
  $now = Get-Date
  $script:BPOE_Current = [pscustomobject]@{ id=$Id; title=$Title; started=$now; tags=$Tags }
  $log = Join-Path (Join-Path $HOME "Documents\GitHub\Godspawn\HH\out") "BPOE-log.md"
  if(!(Test-Path $log)){ "# BPOE Log`r`n" | Out-File -FilePath $log -Encoding utf8NoBOM }
  ("## {0} — {1}  `{2:yyyy-MM-dd HH:mm:ss}`" -f $Id,$Title,$now) | Out-File -Append -FilePath $log -Encoding utf8NoBOM
  ("- precheck: ok (`{0}`)" -f $Tags) | Out-File -Append -FilePath $log -Encoding utf8NoBOM
}
function End-BPOE {
  [CmdletBinding()]param([string]$Outcome="ok",[string]$Notes="")
  if($null -eq $script:BPOE_Current){ return }
  $log = Join-Path (Join-Path $HOME "Documents\GitHub\Godspawn\HH\out") "BPOE-log.md"
  ("- postcheck: {0} {1}" -f $Outcome, (if($Notes){ "— $Notes" } else { "" })) | Out-File -Append -FilePath $log -Encoding utf8NoBOM
  "" | Out-File -Append -FilePath $log -Encoding utf8NoBOM
  $script:BPOE_Current = $null
}
function DO-Header { [CmdletBinding()]param([Parameter(Mandatory)][string]$Id,[Parameter(Mandatory)][string]$Title)
  "# DO-$Id — $Title  (`$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`)"
}