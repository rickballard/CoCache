\
<# ---
title: "Smoke"
brief: "Log engine + PS version"
risk: { writes: false, network: false, secrets: false, destructive: false }
--- #>
"ENGINE: $([IO.Path]::GetFileName($PSHOME))"
$PSVersionTable.PSVersion
