function Start-CoInboxWatcher {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string]$Inbox,
    [Parameter(Mandatory)][string]$ToTag
  )
  try {
    $Inbox = (Resolve-Path $Inbox).Path
  } catch {
    throw "Inbox path not found: $Inbox"
  }
  $fsw = New-Object IO.FileSystemWatcher $Inbox, '*.json'
  $fsw.IncludeSubdirectories = $false
  $fsw.EnableRaisingEvents   = $true
  $id = "inbox_{0}" -f $ToTag

  Register-ObjectEvent -InputObject $fsw -EventName Created -SourceIdentifier $id -Action {
    Start-Sleep -Milliseconds 150
    try {
      $full = $EventArgs.FullPath
      $raw  = Get-Content -LiteralPath $full -Raw -ErrorAction Stop
      $msg  = $raw | ConvertFrom-Json

      if ($msg.to -ne $using:ToTag) { return }

      $logDir = Join-Path (Split-Path $using:Inbox -Parent) 'Logs'
      [IO.Directory]::CreateDirectory($logDir) | Out-Null

      $ack = [pscustomobject]@{
        kind    = 'ack'
        to      = $msg.to
        from    = $env:COMPUTERNAME
        session = $msg.session
        topic   = $msg.topic
        file    = $full
        ts      = (Get-Date).ToUniversalTime().ToString('o')
      }
      $ack | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $logDir ("ack_{0:yyyyMMdd_HHmmssfff}.json" -f (Get-Date))) -Encoding utf8NoBOM
    } catch {
      # swallow; watcher must remain quiet
    }
  } | Out-Null
  "Watcher '$id' on $Inbox (quiet)."
}
