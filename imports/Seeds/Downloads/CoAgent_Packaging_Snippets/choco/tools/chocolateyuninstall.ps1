$dest  = Join-Path $env:USERPROFILE 'Downloads\CoTemp'
if (Test-Path $dest) {
  Write-Host "Leaving CoTemp at $dest (user data). Remove manually if desired."
}
