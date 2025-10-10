CoAgent CoPingPong — Minimal Prototype (PS7)
--------------------------------------------
Goal: Let you keep reading DO briefs while a local CoAgent watches a queue
folder and enqueues actual runnables. You press Enter to execute each one.
No repo changes; this is a local test harness.

Folders it uses (created if missing):
- %USERPROFILE%\Downloads\CoTemps\PingQueue  (drop files here)
- %USERPROFILE%\Downloads\CoTemps\Work       (ephemeral scripts)
- %USERPROFILE%\Downloads\CoTemps\Logs       (execution logs)

What you can drop in PingQueue:
- .ps1 scripts  → queued for execution (press Enter to run)
- .md or .txt   → the agent extracts code fences that follow a line:
                  [PASTE IN POWERSHELL]
                  and enqueues each as a temporary script

Run the agent:
  pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File .\CoAgent.CoPingPong.ps1

Stop the agent:
  Ctrl + C

Safe by design:
- Waits for file size to stabilize before reading (prevents half-writes)
- Shows each item; you must press Enter to run (or 's' to skip, 'q' to quit)
- Logs outputs to Logs\*.log

This is a prototype. You can iterate the parser rules later to fit your preferred
DO label format.
