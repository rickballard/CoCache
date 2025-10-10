# CoAgent — How to send runnable payloads

This repo explains how to send Rick a **runnable ZIP** that CoAgent will execute locally.

## What CoAgent does (today)
- Watches Rick's **Downloads** folder for `*.zip` files.
- If a ZIP contains a **`run.ps1` at the root**, it is extracted and executed with **PowerShell 7**.
- Standard output/error are captured; a summary **CoPong** markdown is written to:
  - `Downloads\CoTemp\CoPong\CoPong_<zipname>_<timestamp>.md`
  - Full work/artifacts live in `Downloads\CoTemp\CoPayloads\<zipname>_<timestamp>\`

## Routing / attribution
- Include a file `_copayload.meta.json` with:
  ```json
  {
    "schema": "copayload.meta.v1",
    "session_hint": "<your-session-name>",
    "reply_url": "<optional-URL>"
  }
  ```
- OR put `__FROM_<your-session-name>__` in the ZIP **filename**.

> **Note**: CoAgent currently does **not** auto-detect browser tab IDs or bind to a specific chat pane. Routing is via the meta file or filename tag above.

## Safety & expectations
- Scripts run **on Rick's machine**. Keep tasks small, explicit, and **reversible**.
- Prefer read-only operations and generating artifacts (markdown, CSV, images, etc.) into `$PSScriptRoot`.
- If you need inputs (API keys, paths), **ask first** in chat and have Rick confirm.

## Minimal structure
```
YourTask/
  run.ps1
  _copayload.meta.json   (optional but recommended)
  ... other data files ...
```
Zip the **contents** of `YourTask/` (not the folder itself) so that `run.ps1` sits at the ZIP root.
