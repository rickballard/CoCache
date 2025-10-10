param([string]$Path = (Join-Path $HOME 'Desktop\CoAgent'))
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$dirs = @('src','scripts','docs','installer','tests','samples')
foreach($d in $dirs){ New-Item -ItemType Directory -Force -Path (Join-Path $Path $d) | Out-Null }

@"
# CoAgent (skeleton)

This is a local skeleton to start shaping the repo before publishing.

- `scripts/` contains the CoTemp runtime and utilities.
- `docs/` holds RFCs, runbooks, PRDs.
"@ | Set-Content -LiteralPath (Join-Path $Path 'README.md') -Encoding UTF8

@"
# ISSUEOPS (draft)

- Use Issues for tasks and RFC discussion.
- Label: `area/runtime`, `area/docs`, `priority/P1-P3`.
- PRs must include a DO log excerpt when applicable.
"@ | Set-Content -LiteralPath (Join-Path $Path 'ISSUEOPS.md') -Encoding UTF8

"Skeleton created at $Path"
