function Add-WatcherToProfile {
  [CmdletBinding()]
  param([Parameter(Mandatory)][string]$ToTag)

  $profile = $PROFILE.CurrentUserAllHosts
  $dir = Split-Path $profile -Parent
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
  if (-not (Test-Path $profile)) { "" | Set-Content -LiteralPath $profile -Encoding utf8NoBOM }

  $line = "try { if (Get-Command Start-CoInboxWatcher -ErrorAction SilentlyContinue) { Start-CoInboxWatcher -Inbox `"$HOME\Downloads\CoTemp\inbox`" -ToTag `"$ToTag`" | Out-Null } } catch {}"
  Add-Content -LiteralPath $profile -Value $line -Encoding utf8NoBOM
  ""  # be quiet
}
