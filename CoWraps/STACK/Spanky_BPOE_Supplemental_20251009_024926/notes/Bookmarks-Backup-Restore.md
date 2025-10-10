# Bookmarks Backup and Restore
Backup:
```powershell
Copy-Item "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Bookmarks" `
          "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Bookmarks.$(Get-Date -Format yyyyMMdd_HHmmss).bak"
```
Restore: Copy only the latest `.bak` back as `Bookmarks` while Chrome is closed.