Param(
  [string]$Repo = 'rickballard/MeritRank',
  [string]$Branch,
  [string]$Workflow = '.github/workflows/merit-badge.yml'
)

if (-not $Branch) { throw "Provide -Branch <name>" }

gh workflow run -R $Repo $Workflow --ref $Branch | Out-Null
$rid = (gh run list -R $Repo --workflow $Workflow --branch $Branch --limit=1 --json databaseId | ConvertFrom-Json)[0].databaseId
if ($rid) { gh run watch -R $Repo $rid }
