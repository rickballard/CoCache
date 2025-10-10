param([Parameter(Mandatory)][int[]]$PR,[string]$Repo,[switch]$Squash=$true)
foreach($n in $PR){
  $args = @('pr','merge',$n,'-R',$Repo,'--auto')
  if($Squash){ $args += '--squash' }
  gh @args
}
