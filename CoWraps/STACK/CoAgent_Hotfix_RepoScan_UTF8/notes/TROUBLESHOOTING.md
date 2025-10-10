# CoAgent Hotfix — RepoScan & UTF-8

This pack fixes two issues:
1) **Repo-scan DO** with smart punctuation or mismatched quotes causing `TerminatorExpectedAtEndOfString`.
2) **Mojibake** in greetings due to non-UTF-8 console/code page.

## Quickstart
```powershell
# 1) UTF-8 console
& "$HOME\Downloads\CoAgent_Hotfix_RepoScan_UTF8\scripts\Set-UTF8.ps1"

# 2) Normalize greetings (ASCII hyphens/quotes)
& "$HOME\Downloads\CoAgent_Hotfix_RepoScan_UTF8\scripts\Normalize-Greetings.ps1"

# 3) Re-queue a clean read-only repo scan
& "$HOME\Downloads\CoAgent_Hotfix_RepoScan_UTF8\scripts\New-DO-RepoScan-ReadOnly.ps1"

# 4) (Optional) Rewrite any previously queued/broken RepoScan DOs
& "$HOME\Downloads\CoAgent_Hotfix_RepoScan_UTF8\scripts\Fix-RepoScan-LogsAndDOs.ps1"
```
