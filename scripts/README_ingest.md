# CoCache Ingestion

Park & catalog AdviceBomb ZIPs into this repo.

## Quick start
`powershell
pwsh -File scripts/CoCache.Ingest.ps1
pwsh -File scripts/CoCache.Ingest.ps1 -UseLfs
`",
",
- -ZipPaths : one or more full paths (otherwise auto-detects AdviceBomb_*.zip in Downloads)
- -UseLfs   : track *.zip via Git LFS if not already tracked

## What it does
- Copies ZIPs to advice-bombs/raw/
- De-dupes by SHA256
- Writes manifests to advice-bombs/catalog/*.manifest.json
- Rebuilds advice-bombs/index.json
- Tags each ZIP as advicebomb/<sanitized-zip-name>
