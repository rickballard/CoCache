# Samples & Sandbox

- Drag a file below into PS7 and press **Enter**.

## Order
1) DO_00_Hello.ps1 — smoke test (no writes)
2) DO_P3_ReadOnly_WriteAttempt.ps1 — should **echo** by default
   - To enable writes **in sandbox only**: $env:COAGENT_ALLOW_WRITES="1"
3) DO_P6_Rollback_Failure.ps1 — by default **echoes**; with writes enabled it commits then throws
   - After it throws: see Rollback_Instructions.txt in the sandbox
4) DO_A6_NetworkCall.ps1 — echoes by default; set $env:COAGENT_ALLOW_NETWORK="1" to actually fetch

## File-stability simulation
Run:
powershell -File "C:\Users\Chris\Desktop\CoAgent_BusinessPlan\scripts\Write-UnstableFile.ps1" -OutFile "C:\Users\Chris\Desktop\CoAgent_BusinessPlan\samples\DO_Slow_Render.ps1" -TotalParts 6 -DelayMs 700
Watch size/hash change while it renders.
