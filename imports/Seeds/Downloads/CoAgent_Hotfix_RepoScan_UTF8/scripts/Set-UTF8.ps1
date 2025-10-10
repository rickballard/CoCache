Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
try { chcp 65001 | Out-Null } catch {}
try { [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false) } catch {}
$OutputEncoding = [System.Text.UTF8Encoding]::new($false)
Write-Host "Console output set to UTF-8." -ForegroundColor Cyan
