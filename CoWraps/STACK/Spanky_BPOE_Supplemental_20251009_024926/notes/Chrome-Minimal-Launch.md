# Chrome Minimal Launch
Use this when diagnosing browser instability.

```powershell
& "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe" `
  --user-data-dir="$env:TEMP\ChromeProbe" `
  --no-first-run --disable-extensions --disable-quic --disable-gpu
```