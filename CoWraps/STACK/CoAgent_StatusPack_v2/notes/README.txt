CoAgent Status Pack v2

Run in PowerShell:

1) Unblock and snapshot
   Set-ExecutionPolicy -Scope Process Bypass -Force
   Get-ChildItem -LiteralPath "$HOME\Downloads\CoTemp" -Recurse -Filter *.ps1 | Unblock-File
   & "$HOME\Downloads\CoAgent_StatusPack_v2\scripts\Capture-StatusSnapshot.ps1"

2) Harvest docs/scripts into your repo working tree (no commits)
   & "$HOME\Downloads\CoAgent_StatusPack_v2\scripts\Harvest-CoTemp-ToRepo.ps1" -RepoPath "$HOME\Desktop\CoAgent"

3) (Optional) Commit
   & "$HOME\Downloads\CoAgent_StatusPack_v2\scripts\Publish-CoAgentDocs.ps1" -RepoPath "$HOME\Desktop\CoAgent"

Note on command chaining:
- Use semicolons (;) or newlines between commands. Writing:  & "A"& "B"  causes the 'AmpersandNotAllowed' parse error.
