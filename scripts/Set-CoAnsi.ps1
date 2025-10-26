$ErrorActionPreference='Stop'; Set-StrictMode -Version Latest
try{
  $supports = ($Host.Name -ne 'ConsoleHost') -or ($PSStyle.OutputRendering -ne 'PlainText')
  if($supports){ $PSStyle.OutputRendering = 'ANSI' }
}catch{}

