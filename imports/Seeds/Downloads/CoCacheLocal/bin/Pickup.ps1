Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path ($env:COCACHE_LOCAL ?? (Join-Path $HOME 'Downloads/CoCacheLocal')) 'sessions'
$h = Get-ChildItem $root -Recurse -Filter 'handover.json' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $h) { Write-Warning "No handover.json found under $root"; return }
$ho = Get-Content $h.FullName -Raw | ConvertFrom-Json
$status = @($ho.status)
$dirty  = ($status | Where-Object { $_ -match '^(?:\?\?| M|M |A |D |R |C |UU|AM|MM| T)' }).Count
Write-Host "=== HANDOVER PICKUP ==="
Write-Host ("File     : {0}" -f $h.FullName)
Write-Host ("Session  : {0}" -f $ho.session_id)
Write-Host ("Agent    : {0}" -f $ho.agent)
Write-Host ("When(UTC): {0}" -f $ho.ts)
Write-Host ("Repo     : {0}" -f $ho.repo)
Write-Host ("Branch   : {0}" -f $ho.branch)
Write-Host ("Dirty    : {0} change(s)" -f $dirty)
if ($status) { Write-Host "--- git status (top) ---"; $status | Select-Object -First 6 | ForEach-Object { Write-Host $_ } }
Write-Host "NEXT: cd `"$($ho.repo)`" ; git status -sb"
