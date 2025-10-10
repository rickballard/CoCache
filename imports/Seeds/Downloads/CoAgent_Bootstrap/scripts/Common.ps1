function CoSafeName([string]$s){
  if(-not $s){return 'x'}
  $t = $s -replace '[^A-Za-z0-9._-]+','-'
  ($t -replace '-{2,}','-').Trim('-').Trim()
}
function CoTsFile(){ (Get-Date).ToUniversalTime().ToString('yyyy-MM-dd_HHmmssZ') }
function CoTsHuman(){ (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ') }
function CoEnsureDir([string]$p){ $fp=[IO.Path]::GetFullPath($p); [IO.Directory]::CreateDirectory($fp)|Out-Null; return $fp }
