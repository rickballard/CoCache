# HOWTO: CoPingPong (Receipt-Only)

- Paste **CoPings** from chat into PS7.
- Let the watcher/processes run quietly.
- Emit **one** receipt at end of cycle with:
  \$Root\scripts\Emit-CoPongReceipt.ps1 -OneLine ...\
- Triple-click the printed line (starts with \# CoPONG:\) and paste it in chat.

**Policy**
- \mit: "external"\ in CoPing.in.json ⇒ watcher does **not** print.
- Only the emitter prints, once, at the end.
