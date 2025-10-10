# CoAgent Sprint 1 — Status Pack

This pack gives you:
- Snapshot/harvest scripts (PowerShell) to capture what's running under `Downloads\CoTemp` and to copy docs into your repo
- A clean **checklist**, **PRD draft**, and **Ops quickstart**
- A **BPOE / workflow** summary of what we configured

---

## Quick start

1) Open **Windows PowerShell** and run:
```
Set-ExecutionPolicy -Scope Process Bypass -Force
Get-ChildItem -LiteralPath "$HOME\Downloads\CoTemp" -Recurse -Filter *.ps1 | Unblock-File
```
2) Unzip this file somewhere (e.g., `Downloads`), then run:
```
& "$HOME\Downloads\CoAgent_Sprint1_StatusPack\scripts\Capture-StatusSnapshot.ps1"
```
3) To copy docs & helper scripts into your **CoAgent** repo working tree:
```
& "$HOME\Downloads\CoAgent_Sprint1_StatusPack\scripts\Harvest-CoTemp-ToRepo.ps1" -RepoPath "$HOME\Desktop\CoAgent"
```
(Review the copy list in the console; it won’t commit — you choose what to add/commit.)

---
Status pack built: 2025-09-10 02:24:54
