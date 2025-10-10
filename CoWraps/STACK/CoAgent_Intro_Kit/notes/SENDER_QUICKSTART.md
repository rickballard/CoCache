# Sender Quickstart (copy/paste friendly)

## 1) Create a folder with a script
Create `run.ps1` at the **root**. Example:
```powershell
# Minimal sample: write an output file
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$out = Join-Path $PSScriptRoot 'out.txt'
'Hello from your payload at {0}' -f (Get-Date -Format o) | Set-Content -Encoding UTF8 $out
Write-Host 'Wrote' $out
```

## 2) (Recommended) Add routing meta
Create `_copayload.meta.json` at the root:
```json
{
  "schema": "copayload.meta.v1",
  "session_hint": "YOUR-SESSION-NAME",
  "reply_url": ""
}
```

## 3) Zip the *contents* so `run.ps1` is at the ZIP root

## 4) Name your file
Option A: any name (meta file handles routing).  
Option B: add `__FROM_YOUR-SESSION-NAME__` into the filename.

## 5) Tell Rick to start CoAgent runner (if needed)
He has a desktop shortcut **“CoPayloadRunner (Manual)”** or can run:
```
& "$env:USERPROFILE\Downloads\CoTemp\tools\CoPayloadRunner.ps1"
```

## 6) Have Rick drag/drop your ZIP into his **Downloads** folder
CoAgent will execute it and return a **CoPong** markdown with status + log tail.
