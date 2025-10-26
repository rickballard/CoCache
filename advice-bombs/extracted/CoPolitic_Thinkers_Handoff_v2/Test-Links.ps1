param(
  [Parameter(Mandatory=$true)] [string] $JsonPath
)
$ErrorActionPreference = "Stop"
if (!(Test-Path $JsonPath)) { throw "Missing JSON: $JsonPath" }
$data = Get-Content $JsonPath -Raw | ConvertFrom-Json

function Test-Head($url){
  try{
    $r = Invoke-WebRequest -Uri $url -Method Head -TimeoutSec 15 -MaximumRedirection 5 -ErrorAction Stop
    return $r.StatusCode
  } catch { return -1 }
}

foreach($t in $data){
  foreach($s in $t.sources){
    if ($s.url){
      $code = Test-Head $s.url
      $status = if($code -eq -1){"ERR"} else {$code}
      "{0} | {1} | {2}" -f $status, $t.name, $s.url
    }
  }
}

