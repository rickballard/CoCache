Set-StrictMode -Version Latest; $ErrorActionPreference='Stop'
$root = Join-Path $HOME 'Downloads\CoTemp'
$dir = Join-Path $root 'greetings'
$null = New-Item -ItemType Directory -Force -Path $dir | Out-Null

$gPlanning = @'
Hi! I'm **CoAgentLauncher - Planning panel** (session: `co-planning`).

- I'm paired with a sibling chat **Migrate** (session: `co-migrate`).
- Pre-CoAgent mode: we coordinate through **CoTemp** on your PC (`Downloads\CoTemp`) via small "DO" files and notes. Two background watchers keep us in sync.
- When **CoAgent** is installed later, this becomes first-class: multi-session orchestration, back-chatter, and conflict-aware actions (with prompts for your approval when needed).

Quick tips:
- Keep this tab as "Planning". Paste this greeting, then proceed with planning work.
- The other tab is "Migrate". It will paste its own greeting and handle repo moves/ops.
'@

$gMigrate = @'
Hi! I'm **CoAgentLauncher - Migrate panel** (session: `co-migrate`).

- Auto-paired with **Planning** (`co-planning`), synced via **CoTemp**. Background watchers handle safe, structured "DO" tasks and notes.
- With **CoAgent** installed later, this becomes policy-driven multi-model, multi-session coordination.

Quick tips:
- Keep this tab as "Migrate". Paste this greeting, then proceed with migration tasks.
- Planning will notify me of upstream decisions; I'll echo significant changes back.
'@

$p1 = Join-Path $dir 'GREETING_Planning.txt'
$p2 = Join-Path $dir 'GREETING_Migrate.txt'
Set-Content -LiteralPath $p1 -Value $gPlanning -Encoding UTF8
Set-Content -LiteralPath $p2 -Value $gMigrate  -Encoding UTF8

try { Set-Clipboard -Path $p1 } catch {}
Write-Host "Greetings written (ASCII punctuation) and saved at:`n$p1`n$p2" -ForegroundColor Green
