param([string]$RepoRoot=(Split-Path -Parent $PSScriptRoot))
$ErrorActionPreference="Stop"; Set-Location $RepoRoot
$readme="README.md"; $src="status\use-summary.json"
if(-not (Test-Path $src)){ "No use-summary.json yet."; exit 0 }
$j=Get-Content $src -Raw | ConvertFrom-Json
$top = ($j.items | Select-Object -First 10)
$lines=@("<!-- BEGIN: USAGE -->","### Usage Activity (last " + $j.windowDays + " days)","Asset | Uses | Last","---|---:|---")
foreach($r in $top){ $lines += ("{0} | {1} | {2}" -f $r.asset,$r.uses,$r.lastTs) }
$lines += "<!-- END: USAGE -->"
$text = if(Test-Path $readme){ Get-Content $readme -Raw } else { "# " + (Split-Path -Leaf $Pwd) + "`n" }
$begin="<!-- BEGIN: USAGE -->"; $end="<!-- END: USAGE -->"
if($text -match [regex]::Escape($begin) -and $text -match [regex]::Escape($end)){
  $pre=$text.Substring(0,$text.IndexOf($begin)); $post=$text.Substring($text.IndexOf($end)+$end.Length)
  $text = ($pre.TrimEnd()+[Environment]::NewLine+($lines -join [Environment]::NewLine)+[Environment]::NewLine+$post.TrimStart())
} else { $text = ($text.TrimEnd()+[Environment]::NewLine+[Environment]::NewLine+($lines -join [Environment]::NewLine)+[Environment]::NewLine) }
Set-Content -LiteralPath $readme -Value $text -Encoding UTF8
"Updated README usage block."

