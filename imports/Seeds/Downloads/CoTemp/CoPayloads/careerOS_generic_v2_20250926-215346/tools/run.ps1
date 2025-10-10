param([string]$RepoName="careerOS",[string]$GitHubUser="")
if (-not (Test-Path .git)){ git init; git checkout -b main; git add .; git commit -m 'init careerOS sample' }
