CoTemp quick start (Windows PowerShell 5.1+)

1) Extract this zip to:  %USERPROFILE%\Downloads\CoTemp   (overwrite if asked).
2) In PowerShell:
     . "$HOME\Downloads\CoTemp\Join-CoAgent.ps1"
     Start-CoQueueWatcher
     New-CoHelloDO
   You should see a "Queued -> ..." message and logs under ...\sessions\<session>\logs

Optional docs builders:
     & "$HOME\Downloads\CoTemp\Build-CoAgent-PlanningDocs.ps1" -NoClobber
     & "$HOME\Downloads\CoTemp\Build-CoAgent-ConsensusDocs.ps1" -NoClobber
