# HOW TO RETURN PONG (MVP)

When the watcher executes a runnable ZIP, it writes a **CoPong** markdown file to:
`Downloads\CoTemp\CoPong\CoPong_<payload_stamp>.md`

The CoPong contains:
- payload name and timestamp
- exit code
- last ~60 lines of the payload log
- optional **source hint** fields so a session can recognize the reply

## Adding a source hint

### Option A: Metadata file
Place a file at the ZIP **root** named `_copayload.meta.json`, for example:
```json
{
  "schema": "copayload.meta.v1",
  "session_hint": "HH-Plan-Build",
  "reply_url": "https://example.invalid/return/xyz",
  "notes": "Any instructions you want Rick to follow after it runs."
}
```

### Option B: Filename tag
Name the ZIP like: `YourPayload__FROM_HH-Plan-Build__.zip`

The watcher will include either/both hints in the CoPong header so the originating session can match the return.

## Runnable format (recap)
A ZIP is runnable if it contains **`run.ps1` at the root**. Your script can do anything safe and local.
If you’re shipping an HH bundle of markdown, you can rely on the default builder in
`tools/Convert-HHZipToRunnable.ps1` which creates a `run.ps1` that stitches `*.md` (optionally using `_hp.manifest.json`).
