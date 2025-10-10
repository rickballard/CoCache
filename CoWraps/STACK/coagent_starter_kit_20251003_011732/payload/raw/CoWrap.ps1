
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
param([ValidateSet('All','Docs','UI','Guardrails','Metrics','Sandbox')]$Pack='All')

function git() { & git.exe @Args }

$root = Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent
Set-Location $root

$branch = ("pack/{0}-{1:yyyyMMdd-HHmmss}" -f $Pack, (Get-Date))
git checkout -B $branch origin/main 2>$null | Out-Null
git add docs tools .coagent .github 2>$null
git commit -m ("pack: apply {0}" -f $Pack) 2>$null
git push -u origin $branch
$pr = (gh pr create --fill --draft)
$pr
