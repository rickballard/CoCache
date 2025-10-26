param(
  [Parameter(Mandatory=$true)][string]$InputJson,
  [Parameter(Mandatory=$true)][string]$OutMermaid,
  [ValidateSet("TB","LR","BT","RL")][string]$Direction = "LR",
  [string]$Title = ""
)
Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
if(!(Test-Path $InputJson)){ throw "Input not found: $InputJson" }
$data = Get-Content -Raw -LiteralPath $InputJson | ConvertFrom-Json
$dir = if($data.direction){ $data.direction } else { $Direction }
$title = if($data.title){ $data.title } else { $Title }
$lines = @()
if($title){ $lines += "%% $title" }
$lines += "flowchart $dir"
foreach($n in $data.nodes){
  $id = $n.id
  $label = ($n.label -replace '"','\"')
  # Mermaid node with square brackets avoids nested paren/quote escaping issues
  $lines += ("  {0}[""{1}""]" -f $id, $label)
}
foreach($e in $data.edges){
  $from = $e.from; $to = $e.to; $lbl = $e.label
  if([string]::IsNullOrWhiteSpace($lbl)){ $lines += ("  {0} --> {1}" -f $from, $to) }
  else { $lbl = $lbl -replace '"','\"'; $lines += ("  {0} -- ""{1}"" --> {2}" -f $from, $lbl, $to) }
}
$mm = $lines -join "`r`n"
New-Item -ItemType Directory -Force (Split-Path $OutMermaid) | Out-Null
[System.IO.File]::WriteAllText($OutMermaid,$mm,[System.Text.UTF8Encoding]::new($false))
Write-Host "✓ Mermaid: $OutMermaid"
