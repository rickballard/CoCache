$last = gh run list --workflow="pages-build-deployment" --limit 1 --json databaseId,headSha,conclusion -q ".[0]"
$last

