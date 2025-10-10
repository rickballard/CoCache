# WATCHER LIMITATIONS (MVP TRUTH)

- No browser integration: it **cannot** detect the tab, window, or chat that delivered the download.
- No automatic uploads: results stay local unless a script you provide uploads them.
- No scheduled tasks or services: it runs only while its console window is open.
- Only ZIPs that contain a `run.ps1` at the root are executed. Others are ignored with a warning.
- Security: payloads run locally with the current user. Keep payloads simple and review their contents before running.
