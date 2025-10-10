# BPOE — HumanGate (ENTER=DO)

**What**: tiny confirmation gate used by every DO block.
**Default**: CoAgent enables ENTER=DO persistently (User env var). You can always type `no` to abort.

- Env var: `BPOE_HUMANGATE_ENTER_OK=1` (User). Set to `0` to disable.
- API: `Invoke-BpoeHumanGate -Action "<what>" [-AllowEnterAsDo]`
- Behavior:
  - Enabled → **ENTER = proceed**, `no` = abort, `DO/yes` = proceed.
  - Disabled → must type **DO** (or `yes`).

**Why safe?** Works with **multi-line** DO blocks; never strands you at `>>`. Opt-in is user-scoped and reversible.

```powershell
# Toggle
[Environment]::SetEnvironmentVariable('BPOE_HUMANGATE_ENTER_OK','0','User')  # disable
[Environment]::SetEnvironmentVariable('BPOE_HUMANGATE_ENTER_OK','1','User')  # enable
```

```powershell
# Use in scripts
Import-Module ./tools/BPOE/CoHumanGate.psm1 -Force
if (-not (Invoke-BpoeHumanGate "Do something important")) { Write-Host "Aborted."; return }
# …safe, idempotent work…
```

> BPOE rule: **avoid here-strings** in DO blocks. Use line arrays + `-join` to prevent `>>` traps.