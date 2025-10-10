# CoAgent Intro Kit (MVP2)

This kit lets any session quickly **use CoAgent’s “payload → execute → CoPong” workflow** without installing services or Scheduled Tasks.
It includes a manual **Downloads watcher**, a **runnable payload format**, and sample content.

> **Important note (from Rick):** I’m still learning CoAgent. If you (the session) want to use any CoAgent features,
> please give me explicit instructions (copy/paste friendly). If you share a runnable ZIP, I’ll drop it in Downloads and run the watcher.
> The watcher will execute it and return a **CoPong** (a small result card) to you when possible.

## What’s in here
- `tools/CoPayloadRunner.ps1` – Manual watcher: processes any ZIP in Downloads that contains `run.ps1` at the ZIP root.
- `tools/Convert-HHZipToRunnable.ps1` – Wrap an existing HH zip by adding a default `run.ps1` and optional source metadata.
- `tools/CoAgent_SendHealth.ps1` – Optional: produce a depersonalized health JSON (manual, opt-in).
- `tools/CoSign-Text.ps1` – Optional: local HMAC signer using a pseudonymous **civId** (auto-created in `Downloads\CoTemp\identity`).
- `docs/HOW_TO_RETURN_PONG.md` – CoPong format and how to include a source hint back to the originating session.
- `docs/WATCHER_LIMITATIONS.md` – What the watcher can/can’t do (MVP truth). TL;DR: it **cannot** auto-detect browser tab IDs.
- `samples/HH_SAMPLE.zip` – A runnable demo ZIP that writes `HH_Plan.md` and a CoPong card.
- `Setup-CoRunner.ps1` + `Setup-CoRunner.cmd` – One-time setup: put tools into `Downloads\CoTemp`, create a Desktop shortcut, place the sample ZIP in Downloads.

## Quick start (Rick)
1. Unzip this kit anywhere.
2. Double-click **Setup-CoRunner.cmd** (creates `Downloads\CoTemp\tools`, Desktop shortcut, and a demo ZIP).
3. Double-click **CoPayloadRunner (Manual)** on the Desktop to start the watcher.
4. Drop any **runnable** ZIP (with `run.ps1` at its root) into **Downloads**. The watcher will execute it and write:
   - Outputs: `Downloads\CoTemp\CoPayloads\<payload_stamp>\…`
   - Result card: `Downloads\CoTemp\CoPong\CoPong_<payload_stamp>.md`

## Notes on source attribution (MVP reality)
The watcher **does not automatically know** which browser tab or chat spawned the download. To help it route results:
- Include a small JSON at the ZIP root named **`_copayload.meta.json`** (see `docs/HOW_TO_RETURN_PONG.md`), **or**
- Tag the filename like: `YourPayload__FROM_SessionName__.zip`
The watcher will add that info into the CoPong so the right session can recognize the return.

## Privacy
- Nothing is uploaded automatically. CoPong files are written locally.
- Health data (if used) is **manual and opt‑in**; you can review the JSON before sending.
- Pseudonymous signing uses a local key in `Downloads\CoTemp\identity`.
