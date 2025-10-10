Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$urls = @(
  "https://github.com/CoCivium/CoCivium/blob/main/README.md",
  "https://github.com/CoCivium/CoCivium/blob/main/ISSUEOPS.md"
)
foreach($u in $urls){ try { Start-Process $u } catch {} }
