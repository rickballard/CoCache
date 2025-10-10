CoAgent MVP3 Assembler (safe starter pack)
==========================================

What this is
------------
A small set of PowerShell scripts that:
- create a local, file-based registry of your current session URL (if provided via COAGENT_SESSION_URL),
- do a safe, *placeholder-only* patch of the CoAgent orchestrator file, and
- scaffold the assembly/run logs.

It **does not** perform destructive edits. It will back up any file it touches.

How to install
--------------
1) Unzip this folder to your local **Downloads** directory so that you have:
   Downloads/CoAgent_MVP3_Assembler/Run-MVP3-Assembly.ps1
   Downloads/CoAgent_MVP3_Assembler/packs/*.ps1

2) (Recommended) Set your session URL for this terminal only:
   $env:COAGENT_SESSION_URL = 'https://chatgpt.com/c/<your-session-id>'

3) Run the assembly:
   pwsh -File "$HOME/Downloads/CoAgent_MVP3_Assembler/Run-MVP3-Assembly.ps1"

4) Review logs under:
   Downloads/CoAgent_MVP3_Assembler/logs/

What it will change
-------------------
- If your orchestrator file is found (tools/Start-MVP3-Orchestrator.ps1) and you have
  COAGENT_SESSION_URL set, it will replace these literal placeholders only:
    'REPLACE_ME_WITH_URL' or "REPLACE_ME_WITH_URL"  -> <your session URL literal>
    pair_REPLACE_ME_WITH_URL                         -> pair_<sanitized_key>
  The script makes a timestamped .bak copy first and parse-checks after modification.

Undo
----
- Restore the .bak file created next to the orchestrator, or
- Re-run the orchestrator from a clean checkout.

Next steps
----------
This is a safe starter. After it runs cleanly, we can add packs that:
- update the repo plan docs automatically,
- generate onboarding/help content,
- produce a shareable “Idea Card” artifact for training, and
- enable optional commit/push (gated by flags).
