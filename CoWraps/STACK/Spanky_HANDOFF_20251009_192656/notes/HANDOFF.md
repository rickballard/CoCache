# Spanky Handoff

- Generated: 20251009_192656
- Items: 
46
- Folder: 
C:\Users\Chris\Downloads\Spanky_HANDOFF_20251009_192656

## Contents
- zips/  → newest deliverable per session
- Spanky_Master_Index.csv  → key, file, timestamp, status-line
- SHA256SUMS.txt → integrity for each zip

## Next (ingest session handles this)
1) Verify checksums: Get-FileHash -Algorithm SHA256 zips\*.zip vs SHA256SUMS.txt
2) Use Spanky_Master_Index.csv to map keys → files.
3) Import each deliverable per your pipeline.

> NOTE: One or more zips lacked _spanky/out.txt first line; they were green upstream, but you may re-run verify before ingest.
