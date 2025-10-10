CoAgent MVP Runner (Manual)
===========================

WHAT THIS IS
- A small, self-contained payload runner that watches your Downloads folder for *.zip files.
- Each zip should contain a top-level run.ps1 which gets executed in an isolated CoTemp workspace.
- After execution, a "CoPong" markdown opens in Notepad so you can review the result and paste it back to chat/PR.

INSTALL
1) Extract this zip somewhere (e.g., your Downloads).
2) Run: Setup-CoRunner.cmd
   - Installs to: %USERPROFILE%\Downloads\CoTemp
   - Adds Desktop shortcut: "CoPayloadRunner (Manual)"
   - Places a sample zip in your Downloads (HH_SAMPLE.zip)

USE
1) Double-click "CoPayloadRunner (Manual)". Leave the window running.
2) Drop a payload zip (with run.ps1) into your Downloads, or double-click HH_SAMPLE.zip.
3) When the payload finishes, a CoPong .md opens in Notepad with a log tail.

OPTIONAL: Pseudonymous Co-signature
- A small signer script is included:
  pwsh -NoProfile -File "%USERPROFILE%\Downloads\CoTemp\tools\CoSign-Text.ps1" -Text "your short message"
- This prints JSON { civId, avatarCode, sig } which you can paste into the CoPong.

SEND HEALTH (MANUAL)
- "Send CoAgent Health (Manual).cmd" opens a prefilled GitHub Issue with a depersonalized JSON.
- Edit OWNER/REPO inside that CMD before use.

UNINSTALL
- Delete %USERPROFILE%\Downloads\CoTemp and the Desktop shortcut.
- No services or scheduled tasks are created by this kit.
