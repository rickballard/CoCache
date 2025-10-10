param([Parameter(Mandatory)][int[]]$PR,[string]$Repo)
foreach($n in $PR){
  $info = gh pr view $n -R $Repo --json number,title,mergeable,mergeStateStatus,headRefName,baseRefName
  $o = $info | ConvertFrom-Json
  "{0}  {1,-12}  {2,-10}  {3}  ({4}->{5})" -f $o.number,$o.mergeStateStatus,$o.mergeable,$o.title,$o.headRefName,$o.baseRefName
}
