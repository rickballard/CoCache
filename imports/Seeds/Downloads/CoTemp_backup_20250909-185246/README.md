# CoAgent Planning Pack (minimal)
1) Extract to `%USERPROFILE%\Downloads\CoTemp`
2) In PowerShell:
```
. "$HOME\Downloads\CoTemp\Join-CoAgent.ps1"
Start-CoQueueWatcher
& "$HOME\Downloads\CoTemp\Build-CoAgent-PlanningDocs.ps1" -NoClobber
```