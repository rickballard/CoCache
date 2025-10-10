param([switch]$VerboseReport)
$report = [ordered]@{ Date=(Get-Date);
  PS7 = ($PSVersionTable.PSEdition -eq 'Core');
  PSVersion = $PSVersionTable.PSVersion.ToString();
  HasPSReadLine = [bool](Get-Module -ListAvailable PSReadLine);
  DockerCli = [bool](Get-Command docker -ErrorAction SilentlyContinue);
  WindowsTerminal = Test-Path (Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps\wt.exe');
  CoAgentRepo = Test-Path "$HOME\Documents\GitHub\CoAgent";
  PanelExe = Test-Path "$HOME\Documents\GitHub\CoAgent\electron\dist\win-unpacked\CoAgent.exe";
  ExecPortOpen = $false
}
try{
  $tcp = [Net.Sockets.TcpClient]::new()
  $iar = $tcp.BeginConnect('127.0.0.1',7681,$null,$null)
  $report.ExecPortOpen = $iar.AsyncWaitHandle.WaitOne(200) -and $tcp.Connected
  $tcp.Close()
}catch{}
if($VerboseReport){ $report } else { $report.GetEnumerator() | %{"{0}: {1}" -f $_.Key,$_.Value} }
