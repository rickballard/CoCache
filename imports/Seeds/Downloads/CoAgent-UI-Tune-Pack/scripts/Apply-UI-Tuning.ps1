[CmdletBinding()]
param([string]$RepoPath="$HOME\Documents\GitHub\CoAgent")
$ErrorActionPreference='Stop'
$repo = Resolve-Path $RepoPath -ErrorAction SilentlyContinue
if (-not $repo) { throw "Repo not found: $RepoPath" }
$assets = Join-Path $repo "assets\ui"
New-Item -ItemType Directory -Force -Path $assets | Out-Null
Copy-Item -Path (Join-Path $PSScriptRoot "..\assets\ui\CoAgentTheme.css") -Destination (Join-Path $assets "CoAgentTheme.css") -Force
Copy-Item -Path (Join-Path $PSScriptRoot "..\assets\ui\CoAgentTheme.js")  -Destination (Join-Path $assets "CoAgentTheme.js")  -Force
$renderer = @(
  "electron\src\renderer\index.tsx","electron\src\renderer\index.jsx",
  "electron\renderer\index.tsx","electron\renderer\index.jsx",
  "electron\src\index.tsx","electron\src\index.jsx"
) | ForEach-Object { Join-Path $repo $_ } | Where-Object { Test-Path $_ }
$html = @(
  "electron\public\index.html","electron\src\renderer\index.html",
  "electron\static\index.html","electron\index.html"
) | ForEach-Object { Join-Path $repo $_ } | Where-Object { Test-Path $_ }
function Add-Import($file) {
  $raw = Get-Content -Raw $file
  $rel  = [IO.Path]::GetRelativePath((Split-Path $file -Parent), (Join-Path $repo "assets\ui")) -replace '\\','/'
  $css  = "import `"$rel/CoAgentTheme.css`";"
  $js   = "import `"$rel/CoAgentTheme.js`";"
  if ($raw -notmatch [regex]::Escape($css)) { $raw = $css + "`r`n" + $raw }
  if ($raw -notmatch [regex]::Escape($js))  { $raw = $js  + "`r`n" + $raw }
  Set-Content -Encoding UTF8 $file $raw
}
function Add-Link($file) {
  $raw = Get-Content -Raw $file
  $head = [regex]'<head[^>]*>'
  $rel  = [IO.Path]::GetRelativePath((Split-Path $file -Parent), (Join-Path $repo "assets\ui")) -replace '\\','/'
  $css  = "<link rel=""stylesheet"" href=""$rel/CoAgentTheme.css"">"
  $js   = "<script src=""$rel/CoAgentTheme.js""></script>"
  if ($head.IsMatch($raw)) {
    if ($raw -notmatch [regex]::Escape($css)) { $raw = $head.Replace($raw, {param($m) $m.Value + "`n  $css" }, 1) }
    if ($raw -notmatch [regex]::Escape($js))  { $raw = $head.Replace($raw, {param($m) $m.Value + "`n  $js"  }, 1) }
    Set-Content -Encoding UTF8 $file $raw
  }
}
if ($renderer) { foreach($f in $renderer){ Add-Import $f } }
elseif ($html) { foreach($f in $html){ Add-Link $f } }
if (Test-Path (Join-Path $repo '.git')) { Push-Location $repo; try { git add -A; if (-not (git diff --cached --quiet)) { git commit -m "style(ui): unify font scale + theme tokens" } } finally { Pop-Location } }
