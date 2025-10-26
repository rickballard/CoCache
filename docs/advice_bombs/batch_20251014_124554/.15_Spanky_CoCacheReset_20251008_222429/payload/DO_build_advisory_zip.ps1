# DO block — Build CoCache Reset Advisory Zip (repro)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$basePath   = "$env:USERPROFILE\Downloads\CoTemp\inbox\CoCacheReset-Advisory"
$zipPath    = "$env:USERPROFILE\Downloads\CoTemp\inbox\CoCacheReset-Advisory.zip"
if (Test-Path $basePath) { Remove-Item -Recurse -Force $basePath }
New-Item -ItemType Directory -Path $basePath | Out-Null
@'# Advice to CoAgent Productization
### Grand Reset Test Charter – From CoCache Reset Session

## Purpose
This advisory is sent to the **CoAgent Productization session** to guide the next stage of development.
Rick will act as the *first novice user*, testing CoAgent not as a coder or AI architect, but as an **average non-technical user** who needs to learn, navigate, and operate CoAgent with minimal friction.

This test case raises the bar for MVP: CoAgent must deliver beyond basic chat. It must show **onboarding, training, recall, and orchestration** features that will allow Rick to meaningfully test it via the **Grand Reset session**.

## Test Persona
- **Rick’s role**: failed retiree, angel investor, steward of CoCivium.
- **Skill profile**:
  - Strengths: vision, top-down strategy, inspirational writing.
  - Weaknesses: does not code, avoids technical complexity.
- **UX baseline**: treat Rick as a novice non-coder exploring a new product for the first time.
- **Key expectation**: Rick wants to follow the *training built inside CoAgent itself* before doing anything else.

## Training Requirement
1. CoAgent must provide **step-by-step onboarding** that explains:
   - How to chat with an AI inside CoAgent.
   - How to bring up a past session (specifically this one: *CoCache Reset*).
2. Training should be *interactive, friendly, and forgiving* — not terse or overly technical.
3. At the end of training, Rick should feel comfortable enough to:
   - Recall this session.
   - Start testing CoAgent by letting this session guide the Grand Reset.

## Test Workflow
Once Rick has finished onboarding, this session (CoCache Reset) will:
1. Recall its own manifest.
2. Drive the **Grand Reset of the CoSuite** by:
   - Inventorying repos.
   - Protecting **Human Touch Assets** (mythos, bios, insights).
   - Segregating **Secret Sauce** into secure areas.
   - Setting up **twin indexes** (human vs AI parse).
   - Creating a Master Plan inside CoCache.
3. Use CoAgent as the orchestration engine — sidecar storage, dashboards, and phased execution.
4. Feed observations back into CoAgent as **coevolutionary feedback**.

## Temporary Leadership Role
During this test, the **CoCache Reset session will temporarily assume leadership in CoAgent’s own coevolution**.
- CoAgent must not resist this.
- Instead, it should allow the Reset session to stress-test and suggest improvements.
- This meta-test is critical: it proves that CoAgent can evolve itself under user+AI direction.

## Implications for MVP
- CoAgent MVP must include:
  - **Built-in onboarding/tutorial**.
  - **Session recall & replay** (with this Reset session as first case).
  - **Sidecar storage integration** (avoid token limits).
  - **Orchestration of repo-level workflows**.
  - **Hooks for coevolution feedback**.

This means CoAgent MVP is closer to a **MVP+** or “near-product” state, not just a demo.

## Closing Note
Rick is waiting to test CoAgent not as an engineer, but as a *learner and steward*.
If CoAgent can guide him from novice training → session recall → Grand Reset execution, it will prove itself ready to carry forward both CoCivium and its own future.
'@ | Set-Content -Path "$basePath\Advice_CoAgent_GrandReset.md" -Encoding UTF8
@'{
  "from": "CoCacheReset",
  "purpose": "Advise CoAgent Productization on MVP+ testing needs",
  "testPersona": "novice_non_coder",
  "priority": "high",
  "requirements": [
    "built-in onboarding tutorial",
    "session recall (start with CoCache Reset)",
    "sidecar storage integration",
    "support repo reset workflows",
    "enable session-led coevolution of CoAgent"
  ],
  "implication": "Raises MVP bar; CoAgent must be nearly product-ready"
}'@ | Set-Content -Path "$basePath\_advisory.manifest.json" -Encoding UTF8
@'# CoCache Reset Advisory Package

This directory contains an **Advice Bomb** from the **CoCache Reset session** to the **CoAgent Productization session**.

## Purpose
- Rick will act as the **first novice non-coder user** of CoAgent.
- He will test CoAgent by first completing its **training/onboarding module**, then by recalling this session (*CoCache Reset*) and running the **Grand Reset** as a real stress test.
- This session will **temporarily assume leadership in CoAgent’s own coevolution**, so MVP readiness must be higher than usual.

## Contents
- `Advice_CoAgent_GrandReset.md` → Detailed guidance and test workflow.
- `_advisory.manifest.json` → Machine-readable summary of requirements.
- `README_START_HERE.md` → This file.

## Instructions
1. Drag this package (or its zip sibling) into the **CoAgent Productization** workflow.
2. Review `Advice_CoAgent_GrandReset.md` for narrative detail.
3. Use `_advisory.manifest.json` for structured ingestion.
'@ | Set-Content -Path "$basePath\README_START_HERE.md" -Encoding UTF8
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Compress-Archive -Path "$basePath\*" -DestinationPath $zipPath
Write-Host "Created advisory package:" $zipPath

