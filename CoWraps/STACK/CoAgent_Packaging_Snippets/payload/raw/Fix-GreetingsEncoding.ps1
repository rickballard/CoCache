Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
# Set console to UTF-8 and normalize greeting files to UTF‑8
try { chcp 65001 | Out-Null } catch {}
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
$greetDir = Join-Path $HOME 'Downloads\CoTemp\greetings'
if (Test-Path $greetDir) {
  Get-ChildItem -LiteralPath $greetDir -Filter *.txt | ForEach-Object {
    $t = Get-Content -Raw -LiteralPath $_.FullName
    Set-Content -LiteralPath $_.FullName -Encoding UTF8 -Value $t
  }
  Write-Host "Greetings normalized to UTF‑8. If you still see mojibake, paste into Notepad and copy from there." -ForegroundColor Green
} else {
  Write-Warning "No greetings directory found at $greetDir"
}
