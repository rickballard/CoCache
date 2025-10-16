$bad = git ls-files -z secrets/*.json | % { $_ -replace "`0","" } | ? { $_ -notmatch '\.enc\.json$' }
if ($bad) { Write-Error "Plaintext secrets blocked:`n$($bad -join "`n")"; exit 1 }
