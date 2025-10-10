# BPOE_notes_links.md

TODO: Collect links/snippets here.


---
### Harvest @ 2025-09-08 03:18


#### CoCivium/.githooks\post-commit-record-oe.ps1
> if(-not $hasSnap){ Write-Host "[hint] Tools changed. Consider:  pwsh admin/tools/bpoe/Record-Env.ps1" -ForegroundColor Yellow }

#### CoCivium/.reports\inventory-20250827-2246.md
> 051f1ca docs: add Integration Advisory ΓÇö product shutdown/cleanup (session-only trigger, gates cleared, no profile writes)

#### CoCivium/admin\bpoe\mitigations\2025-09-05_advisory-green-but-blocked.md
> _This doc is part of the BPOE “Known Issues & Mitigations” series._

#### CoCivium/admin\bpoe\mitigations\2025-09-05_advisory-green-but-blocked_fix.md
> _This doc is part of BPOE “Known Issues & Mitigations”._

#### CoCivium/admin\bpoe\mitigations\2025-09-05_mergeability-cache-and-checks.md
> **Branch/PR:** `docs/bpoe-known-issues-20250905` / PR #347

#### CoCivium/admin\bpoe\20250815_070419Z_bpoe_update.md
> # BPOE update — 20250815_070419Z

#### CoCivium/admin\bpoe\rebase-stub-vs-canonical.md
> # BPOE: Rebase pattern for stub vs canonical

#### CoCivium/admin\bpoe\_index.md
> # BPOE — Known Issues & Mitigations

#### CoCivium/admin\history\inventory\REPO_SWEEP_20250821_225702.md
> C:\\Users\\Chris\\Documents\\GitHub\\CoCivium\\admin\\bpoe\\20250815\_070419Z\_bpoe\_update.md

#### CoCivium/admin\history\pads\RickPad_20250821c.md
> 10. **P3 — CivicOpsEng** (first hire/contract profile + checklist) · `status=draft`

#### CoCivium/admin\history\Browser_Setup_and_Launcher_20250809T054950Z.md
> **Goal.**  Isolate a clean Chrome profile (“CoCivium”) with the right extensions and startup tabs so our sessions are repeatable and fast.

#### CoCivium/admin\history\Intersessional_Profile_20250809T054732Z.md
> # Intersessional Profile – CoCivium (v1)

#### CoCivium/admin\history\OE_Snapshot_20250815_1657.md
> # OE/BPOE Snapshot — 2025-08-15 16:57

#### CoCivium/admin\history\Reminder_Run_20250818_010604_760.md
> If today is Monday, also remind me to capture an OE snapshot with `pwsh -File admin/tools/bpoe/Record-Env.ps1`.

#### CoCivium/admin\history\Reminder_Run_20250818_010829_944.md
> If today is Monday, also remind me to capture an OE snapshot with `pwsh -File admin/tools/bpoe/Record-Env.ps1`.

#### CoCivium/admin\history\Reminder_Run_20250818_011957_427.md
> If today is Monday, also remind me to capture an OE snapshot with `pwsh -File admin/tools/bpoe/Record-Env.ps1`.

#### CoCivium/admin\history\Reminder_Run_20250818_095641_713.md
> If today is Monday, also remind me to capture an OE snapshot with `pwsh -File admin/tools/bpoe/Record-Env.ps1`.

#### CoCivium/admin\history\Reminder_Run_20250818_095930_690.md
> If today is Monday, also remind me to capture an OE snapshot with `pwsh -File admin/tools/bpoe/Record-Env.ps1`.

#### CoCivium/admin\history\Reminder_Run_20250825_125131_601.md
> If today is Monday, also remind me to capture an OE snapshot with `pwsh -File admin/tools/bpoe/Record-Env.ps1`.

#### CoCivium/admin\history\WORKFLOW-LEARNINGS-20250826.md
> 1) **Profile hardening.** Never dot-source missing scripts.  Guard with `Test-Path` + `try/catch`; provide harmless stubs for calls that shouldn’t fail session start.

#### CoCivium/admin\hold\hold_Civium_Term_Psalter (1).md
> ## TRUST PROFILE

#### CoCivium/admin\hold\hold_Strategy_Stnexid_Profile_c1_20250802.md
> This document serves as the founding strategic profile for **Stnexid**, a dual-layer system within the Civium architecture that facilitates high-fidelity cognitive transmission, comparison, and convergence between minds.

#### CoCivium/admin\hold\hold_TODO_Stnexid_Interface_Track_c1.md
> - [x] Draft strategic profile (`Strategy_Stnexid_Profile_c1_20250802.md`)

#### CoCivium/admin\hold\hold_TODO_Trust_Profiles_Public_Ledger.md
> - Determine minimum schema for a trust profile (e.g., vote weight, verification count, alignment deltas)

#### CoCivium/admin\inbox\GmailDump_20250811\originals\CoCivium_Session_Primer (1).md
> > Maintain our intersessional profile conventions, filename formats, tone (‘Challenge Perspective’ for critique), no ego-pandering, and near-final doc improvement checks.

#### CoCivium/admin\inbox\GmailDump_20250811\originals\Last_Session_Context.md
> - Use filename formats and repo structure rules from intersessional profile.

#### CoCivium/admin\inbox\GmailDump_20250811\originals\Strategy_Stnexid_Profile_c1_20250802.md
> This document serves as the founding strategic profile for **Stnexid**, a dual-layer system within the Civium architecture that facilitates high-fidelity cognitive transmission, comparison, and convergence between minds.

#### CoCivium/admin\inbox\GmailDump_20250811\originals\TODO_Stnexid_Interface_Track_c1.md
> - [x] Draft strategic profile (`Strategy_Stnexid_Profile_c1_20250802.md`)

#### CoCivium/admin\inbox\GmailDump_20250811\originals\TODO_Trust_Profiles_Public_Ledger.md
> - Determine minimum schema for a trust profile (e.g., vote weight, verification count, alignment deltas)

#### CoCivium/admin\outreach\KickOpenAI\Appendix\CoCivium_OpenAI_Bugs_Appendix_2025-08-12.md
> - GitHub (public profile): `github.com/rickballard`

#### CoCivium/admin\products\CoCivBus\PLAN_v0.1.md
> - **CLI/PS clients.** PS7 first, Node CLI for cross‑platform.

#### CoCivium/admin\setup\Browser_Setup_and_Launcher.md
> One-click opens CoCivium Chrome profile with pinned tabs + two Git Bash tabs.

#### CoCivium/admin\setup\chrome_profile_summary_20250809T071539Z.md
> # Chrome Profile Summary (20250809T071539Z)

#### CoCivium/admin\setup\chrome_profile_summary_20250809T074129Z.md
> # Chrome Profile Summary (20250809T074129Z)

#### CoCivium/admin\setup\ENVIRONMENT.md
> ## Browser profile

#### CoCivium/admin\setup\Profile.Snippet.ps1
> # Profile helpers (safely dot-sourced)

#### CoCivium/admin\setup\RepoAccelerator-Uninstall.ps1
> # Remove profile block

#### CoCivium/admin\setup\RepoAccelerator.ps1
> # Offer to link a profile snippet (dot-source only; reversible)

#### CoCivium/admin\setup\snapshot_chrome_config.ps1
> $summary.profile            = $ProfileDir

#### CoCivium/admin\setup\Workbench_Setup_Plan.md
> # CoCivium One-Click Workbench — Setup Plan (v0.1, 2025-08-09)

#### CoCivium/admin\system\bpoe-audit\BPOE_Audit_20250813_192734.md
> # BPOE Environment Audit (20250813_192734)

#### CoCivium/admin\tools\bpoe\Record-Env.ps1
> # Record-Env.ps1 — capture local OE/BPOE with per-tool timeouts (v0.8)

#### CoCivium/admin\tools\reminders\Run-ReminderHub.ps1
> $body += 'If today is Monday, also remind me to capture an OE snapshot with `pwsh -File admin/tools/bpoe/Record-Env.ps1`.'

#### CoCivium/admin\tools\workbench\README.md
> # Workbench

#### CoCivium/admin\Intersessional_Profile.md
> # Intersessional Profile – CoCivium (v1)

#### CoCivium/admin\Last_Session_Context.md
> - 2025-08-09T07:33:08Z — Built Chrome Upgrade Pack; review CHANGES.md; next: snapshot actual Chrome profile (“Profile 1”), repopulate manifest with core extensions, rebuild pack.

#### CoCivium/admin\TODO_Trust_Profiles_Public_Ledger.md
> - Determine minimum schema for a trust profile (e.g., vote weight, verification count, alignment deltas)

#### CoCivium/deprecated\holding\Civium_Term_Psalter.md
> ## TRUST PROFILE

#### CoCivium/docs\academy\BP_OE_WF.md
> 1) Install PS7, git, gh, node, python (dotnet optional).

#### CoCivium/docs\academy\REPO_ACCELERATOR.md
> 1) Install PS7, git, gh, node, python (dotnet optional).

#### CoCivium/docs\backlog\ADVANCED.md
> - [ ] **Workbench polish & tests**

#### CoCivium/docs\BPOE\ISSUEOPS.md
> - **CoProtect** — Apply branch-protection per `docs/bpoe/prefs.yml`.

#### CoCivium/docs\BPOE\LESSONS.md
> - 2025-08-24T13:27:41 — PS7 microtext + scan-for-red speeds selection and reduces visual load.

#### CoCivium/docs\BPOE\PLAYBOOKS.md
> # BPOE — Doc-only PRs (README, *.md)

#### CoCivium/docs\BPOE\Workflow.md
> # BPOE / Workflow (v0)

#### CoCivium/docs\cc\_imports\civium_20250826_1109\insights_Insight_AI_Veto_c4_20250801.md
> 5. **Update Trust Profile metadata**

#### CoCivium/docs\cc\_imports\civium_20250826_1109\insights_Insight_Radiant_Network_c4_20250801.md
> - **Trust Profile**

#### CoCivium/docs\cc\_imports\civium_20250826_1109\insights_Insight_Rights_Alignment_c3_20250801.md
> - **Obsolete AIs**: Evaluated for memory-chain coherence + harm profile

#### CoCivium/docs\cc\_imports\civium_20250826_1109\insights_Insight_Truth_Metrics_c6_20250801.md
> Civium acknowledges the unique epistemic profile of artificial intelligences.

#### CoCivium/docs\cotips\VOICE-PASTE-CUE.md
> When pasting DO blocks into PS7, Windows may ask for confirmation.

#### CoCivium/docs\funding\OPEN_COLLECTIVE.md
> - Add your legal name + payout method in your own contributor profile.

#### CoCivium/docs\ops\CoWrap_Import_250828-0216\CoCivium_CoWrap_20250828_0604\attached\CoCivium_RickPad_Supplemental.md
> - `people/rick.md` — profile of Rick (ethos, style, preferences, notable work).

#### CoCivium/docs\ops\CoWrap_Import_250828-0216\CoCivium_CoWrap_20250828_0604\attached\CoWrap_Short_Checklist.md
> # CoWrap – Short Checklist

#### CoCivium/docs\ops\CoWrap_Import_250828-0216\CoCivium_CoWrap_20250828_0604\00_README.md
> # CoCivium CoWrap Pack — 20250828_0604

#### CoCivium/docs\ops\CoWrap_Import_250828-0216\CoCivium_CoWrap_20250828_0604\01_Forward_Plan.md
> - [ ] **CoPong v0.4.4** — verify module imports cleanly on PS5/PS7; add Pester tests; lock‑free transcript confirmed.

#### CoCivium/docs\ops\CoWrap_Import_250828-0216\CoCivium_CoWrap_20250828_0604\07_CoPong_v0.4.4_Notes.md
> - Pester tests: import on PS5/PS7; clipboard flow; lock‑free behavior.

#### CoCivium/docs\ops\CoWrap_Import_250828-0216\CoCivium_CoWrap_20250828_0604\09_Backlog_Priorities.md
> - CoWrap template (short up top; idea pack behind link).

#### CoCivium/docs\ops\policy\BP_ASSISTANT_BLOCKS.md
> - **Manual paste of PS7 output counts as a CoPong** for the active set.

#### CoCivium/docs\ops\PARKING_LOT.md
> - [2025-08-28 02:17] Imported extra CoWrap files into C:\Users\Chris\Documents\GitHub\CoCivium\docs\ops\CoWrap_Import_250828-0216; triage later.

#### CoCivium/docs\product\PITCH-OPENAI.md
> **Integration:** GPT with Actions calls CoAgent API; no profile writes; wash-away hooks.

#### CoCivium/docs\security\README.md
> - No profile edits; session-only behavior.

#### CoCivium/docs\BPOE.md
> # BPOE / Workflow Record

#### CoCivium/docs\cli-guardrails.md
> **Always re-orient PS7 before any new instruction set.** Use:

#### CoCivium/docs\community-objectives.md
> - Every action leaves a trace (BPOE, issues, PR notes, logs).

#### CoCivium/docs\ISSUEOPS.md
> - **Manual paste of PS7 output** in chat counts as a CoPong.

#### CoCivium/docs\NAVMAP_c1_20250827.md
> - BPOE / Playbooks

#### CoCivium/docs\REPOACCELERATOR.md
> # RepoAccelerator (Workbench)

#### CoCivium/identity\Identity_Poetics.md
> Identity in Civium is not fixed; it arises in context, purpose, and alignment. A being’s “self” is a dynamic resonance across time, memory, and intent—not a static profile.

#### CoCivium/insights\ai-veto.md
> 5. **Update Trust Profile metadata**

#### CoCivium/insights\Insight_AI_Veto_c4_20250801.md
> 5. **Update Trust Profile metadata**

#### CoCivium/insights\Insight_Radiant_Network_c4_20250801.md
> - **Trust Profile**

#### CoCivium/insights\Insight_Rights_Alignment_c3_20250801.md
> - **Obsolete AIs**: Evaluated for memory-chain coherence + harm profile

#### CoCivium/insights\Insight_Truth_Metrics_c6_20250801.md
> Civium acknowledges the unique epistemic profile of artificial intelligences.

#### CoCivium/insights\radiant-network.md
> - **Trust Profile**

#### CoCivium/insights\rights-alignment.md
> - **Obsolete AIs**: Evaluated for memory-chain coherence + harm profile

#### CoCivium/insights\truth-metrics.md
> CoCivium acknowledges the unique epistemic profile of artificial intelligences.

#### CoCivium/legacy\Civium\admin\hold\hold_Civium_Term_Psalter (1).md
> ## TRUST PROFILE

#### CoCivium/legacy\Civium\admin\hold\hold_Strategy_Stnexid_Profile_c1_20250802.md
> This document serves as the founding strategic profile for **Stnexid**, a dual-layer system within the CoCivium architecture that facilitates high-fidelity cognitive transmission, comparison, and convergence between minds.

#### CoCivium/legacy\Civium\admin\hold\hold_TODO_Stnexid_Interface_Track_c1.md
> - [x] Draft strategic profile (`Strategy_Stnexid_Profile_c1_20250802.md`)

#### CoCivium/legacy\Civium\admin\hold\hold_TODO_Trust_Profiles_Public_Ledger.md
> - Determine minimum schema for a trust profile (e.g., vote weight, verification count, alignment deltas)

#### CoCivium/legacy\Civium\admin\inbox\GmailDump_20250811\originals\CoCivium_Session_Primer (1).md
> > Maintain our intersessional profile conventions, filename formats, tone (‘Challenge Perspective’ for critique), no ego-pandering, and near-final doc improvement checks.

#### CoCivium/legacy\Civium\admin\inbox\GmailDump_20250811\originals\Last_Session_Context.md
> - Use filename formats and repo structure rules from intersessional profile.

#### CoCivium/legacy\Civium\admin\inbox\GmailDump_20250811\originals\Strategy_Stnexid_Profile_c1_20250802.md
> This document serves as the founding strategic profile for **Stnexid**, a dual-layer system within the CoCivium architecture that facilitates high-fidelity cognitive transmission, comparison, and convergence between minds.

#### CoCivium/legacy\Civium\admin\inbox\GmailDump_20250811\originals\TODO_Stnexid_Interface_Track_c1.md
> - [x] Draft strategic profile (`Strategy_Stnexid_Profile_c1_20250802.md`)

#### CoCivium/legacy\Civium\admin\inbox\GmailDump_20250811\originals\TODO_Trust_Profiles_Public_Ledger.md
> - Determine minimum schema for a trust profile (e.g., vote weight, verification count, alignment deltas)

#### CoCivium/legacy\Civium\admin\TODO_Trust_Profiles_Public_Ledger.md
> - Determine minimum schema for a trust profile (e.g., vote weight, verification count, alignment deltas)

#### CoCivium/legacy\Civium\deprecated\holding\Civium_Term_Psalter.md
> ## TRUST PROFILE

#### CoCivium/legacy\Civium\identity\Identity_Poetics.md
> Identity in CoCivium is not fixed; it arises in context, purpose, and alignment. A being’s “self” is a dynamic resonance across time, memory, and intent—not a static profile.

#### CoCivium/legacy\Civium\insights\Insight_AI_Veto_c4_20250801.md
> 5. **Update Trust Profile metadata**

#### CoCivium/legacy\Civium\insights\Insight_Radiant_Network_c4_20250801.md
> - **Trust Profile**

#### CoCivium/legacy\Civium\insights\Insight_Rights_Alignment_c3_20250801.md
> - **Obsolete AIs**: Evaluated for memory-chain coherence + harm profile

#### CoCivium/legacy\Civium\insights\Insight_Truth_Metrics_c6_20250801.md
> CoCivium acknowledges the unique epistemic profile of artificial intelligences.

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\history\Browser_Setup_and_Launcher_20250809T054950Z.md
> **Goal.**  Isolate a clean Chrome profile (“CoCivium”) with the right extensions and startup tabs so our sessions are repeatable and fast.

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\history\Intersessional_Profile_20250809T054732Z.md
> # Intersessional Profile – CoCivium (v1)

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\outreach\KickOpenAI\Appendix\CoCivium_OpenAI_Bugs_Appendix_2025-08-12.md
> - GitHub (public profile): `github.com/rickballard`

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\setup\Browser_Setup_and_Launcher.md
> One-click opens CoCivium Chrome profile with pinned tabs + two Git Bash tabs.

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\setup\chrome_profile_summary_20250809T071539Z.md
> # Chrome Profile Summary (20250809T071539Z)

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\setup\chrome_profile_summary_20250809T074129Z.md
> # Chrome Profile Summary (20250809T074129Z)

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\setup\ENVIRONMENT.md
> ## Browser profile

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\setup\snapshot_chrome_config.ps1
> $summary.profile            = $ProfileDir

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\setup\Workbench_Setup_Plan.md
> # CoCivium One-Click Workbench — Setup Plan (v0.1, 2025-08-09)

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\Intersessional_Profile.md
> # Intersessional Profile – CoCivium (v1)

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\Last_Session_Context.md
> - 2025-08-09T07:33:08Z — Built Chrome Upgrade Pack; review CHANGES.md; next: snapshot actual Chrome profile (“Profile 1”), repopulate manifest with core extensions, rebuild pack.

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\admin\hold\hold_Civium_Term_Psalter (1).md
> ## TRUST PROFILE

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\admin\hold\hold_Strategy_Stnexid_Profile_c1_20250802.md
> This document serves as the founding strategic profile for **Stnexid**, a dual-layer system within the CoCivium architecture that facilitates high-fidelity cognitive transmission, comparison, and convergence between minds.

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\admin\hold\hold_TODO_Stnexid_Interface_Track_c1.md
> - [x] Draft strategic profile (`Strategy_Stnexid_Profile_c1_20250802.md`)

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\admin\hold\hold_TODO_Trust_Profiles_Public_Ledger.md
> - Determine minimum schema for a trust profile (e.g., vote weight, verification count, alignment deltas)

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\admin\inbox\GmailDump_20250811\originals\CoCivium_Session_Primer (1).md
> > Maintain our intersessional profile conventions, filename formats, tone (‘Challenge Perspective’ for critique), no ego-pandering, and near-final doc improvement checks.

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\admin\inbox\GmailDump_20250811\originals\Last_Session_Context.md
> - Use filename formats and repo structure rules from intersessional profile.

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\admin\inbox\GmailDump_20250811\originals\Strategy_Stnexid_Profile_c1_20250802.md
> This document serves as the founding strategic profile for **Stnexid**, a dual-layer system within the CoCivium architecture that facilitates high-fidelity cognitive transmission, comparison, and convergence between minds.

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\admin\inbox\GmailDump_20250811\originals\TODO_Stnexid_Interface_Track_c1.md
> - [x] Draft strategic profile (`Strategy_Stnexid_Profile_c1_20250802.md`)

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\admin\inbox\GmailDump_20250811\originals\TODO_Trust_Profiles_Public_Ledger.md
> - Determine minimum schema for a trust profile (e.g., vote weight, verification count, alignment deltas)

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\admin\TODO_Trust_Profiles_Public_Ledger.md
> - Determine minimum schema for a trust profile (e.g., vote weight, verification count, alignment deltas)

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\deprecated\holding\Civium_Term_Psalter.md
> ## TRUST PROFILE

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\identity\Identity_Poetics.md
> Identity in CoCivium is not fixed; it arises in context, purpose, and alignment. A being’s “self” is a dynamic resonance across time, memory, and intent—not a static profile.

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\insights\Insight_AI_Veto_c4_20250801.md
> 5. **Update Trust Profile metadata**

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\insights\Insight_Radiant_Network_c4_20250801.md
> - **Trust Profile**

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\insights\Insight_Rights_Alignment_c3_20250801.md
> - **Obsolete AIs**: Evaluated for memory-chain coherence + harm profile

#### CoCivium/legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\insights\Insight_Truth_Metrics_c6_20250801.md
> CoCivium acknowledges the unique epistemic profile of artificial intelligences.

#### CoCivium/MIGRATION\Session_2025-09-08_0133_FINAL\IdeaCard_3Panel_CoCache_Heartbeat.md
> A **3-panel** UX (ChatGPT | PS7 | ChatGPT) with a shared **CoCache** event log. Add ΓÇ£CoWrapΓÇ¥ to handoff; heartbeat to synchronize; file-based CoPing/CoPong to kill clipboard dependence.

#### CoCivium/MIGRATION\Session_2025-09-08_0133_FINAL\IdeaCard_CoStasis_AllSmokes.md
> - [ ] CI job + local PS7 entrypoint.

#### CoCivium/MIGRATION\STATUS.md
> ## BPOE notes (working)

#### CoCivium/notes\admin\status_20250814_2213.md
> [{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-15T02:58:44Z","headRefName":"ops/status-20250814_2213","number":101,"title":"ops: status snapshot 20250814_2213"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-15T01:01:22Z","headRefName":"holding/todaydump-20250814_2101","number":98,"title":"holding: add TodayDump.zip (+manifest)"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T19:47:49Z","headRefName":"campaign/press-kit-v0-20250814","number":92,"title":"Press kit: consent not coercion ΓÇö CoCivium launches portable governance pack for agentic AI"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T05:53:20Z","headRefName":"reorg/structure-hygiene-20250814_0152","number":67,"title":"reorg: structure + hygiene"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T05:49:52Z","headRefName":"chore/cleanup-protection-artifacts","number":66,"title":"chore: cleanup branch-protection artifacts"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T02:31:55Z","headRefName":"ci/og-image-20250813_2231","number":53,"title":"ci: add OG image renderer"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T02:21:56Z","headRefName":"branding/og-20250813_2221","number":52,"title":"Branding: add OG banner (SVG placeholder)"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T00:24:22Z","headRefName":"gm/preflight-20250813_2024","number":50,"title":"GM Preflight: checkpoint (20250813_2024)"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T00:07:52Z","headRefName":"gm/bpoe-migration-20250813_2007","number":49,"title":"Grand Migration: bootstrap"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-13T01:33:02Z","headRefName":"ci/filename-sanity-fix","number":33,"title":"ci: add filename-sanity workflow"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-13T00:54:58Z","headRefName":"fix/normalize-actions-path","number":31,"title":"ci: normalize workflows; remove stray CPUA path"}]

#### CoCivium/notes\admin\status_20250814_2312.md
> [{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-15T03:07:39Z","headRefName":"triage/todaydump-20250814_2101","number":102,"title":"triage: TodayDump 20250814_2101 ΓåÆ curated locations"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-15T01:01:22Z","headRefName":"holding/todaydump-20250814_2101","number":98,"title":"holding: add TodayDump.zip (+manifest)"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T19:47:49Z","headRefName":"campaign/press-kit-v0-20250814","number":92,"title":"Press kit: consent not coercion ΓÇö CoCivium launches portable governance pack for agentic AI"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T05:53:20Z","headRefName":"reorg/structure-hygiene-20250814_0152","number":67,"title":"reorg: structure + hygiene"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T05:49:52Z","headRefName":"chore/cleanup-protection-artifacts","number":66,"title":"chore: cleanup branch-protection artifacts"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T02:31:55Z","headRefName":"ci/og-image-20250813_2231","number":53,"title":"ci: add OG image renderer"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T02:21:56Z","headRefName":"branding/og-20250813_2221","number":52,"title":"Branding: add OG banner (SVG placeholder)"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T00:24:22Z","headRefName":"gm/preflight-20250813_2024","number":50,"title":"GM Preflight: checkpoint (20250813_2024)"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T00:07:52Z","headRefName":"gm/bpoe-migration-20250813_2007","number":49,"title":"Grand Migration: bootstrap"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-13T01:33:02Z","headRefName":"ci/filename-sanity-fix","number":33,"title":"ci: add filename-sanity workflow"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-13T00:54:58Z","headRefName":"fix/normalize-actions-path","number":31,"title":"ci: normalize workflows; remove stray CPUA path"}]

#### CoCivium/notes\migration\preflight\open_pr_inclusion_manifest.txt
> CoCivium 49 Grand Migration: bootstrap                                     gm/bpoe-migration-20250813_2007 main    https://github.com/rickballard/CoCivium/pull/49 merge-into-migration included

#### CoCivium/scripts\workbench\Preflight.ps1
> $mods = Join-Path $HOME "Documents\GitHub\CoModules\tools\Test-BPOE.ps1"

#### CoCivium/scripts\workbench\Start-CoCiviumWorkbench.ps1
> $inner = Join-Path $repo "scripts\workbench\Workbench-Inner.ps1"

#### CoCivium/scripts\workbench\Workbench-Inner.ps1
> Write-OEStatus -Event 'workbench-launched'

#### CoCivium/scripts\CoVibe.CoLex.ps1
> $doc = Join-Path $PSScriptRoot '..\docs\bpoe\CONTRIBUTING_PREFS.md'

#### CoCivium/scripts\CoVibe.Lessons.ps1
> $dest = Join-Path $PSScriptRoot '..\docs\bpoe\LESSONS.md'

#### CoCivium/scripts\CoVibe.Prefs.ps1
> # Reads docs/bpoe/prefs.yml into a PS object. Requires yq; else returns {}.

#### CoCivium/staging\_imported\Civium\admin\hold\hold_Civium_Term_Psalter (1).md
> ## TRUST PROFILE

#### CoCivium/staging\_imported\Civium\admin\hold\hold_Strategy_Stnexid_Profile_c1_20250802.md
> This document serves as the founding strategic profile for **Stnexid**, a dual-layer system within the CoCivium architecture that facilitates high-fidelity cognitive transmission, comparison, and convergence between minds.

#### CoCivium/staging\_imported\Civium\admin\hold\hold_TODO_Stnexid_Interface_Track_c1.md
> - [x] Draft strategic profile (`Strategy_Stnexid_Profile_c1_20250802.md`)

#### CoCivium/staging\_imported\Civium\admin\hold\hold_TODO_Trust_Profiles_Public_Ledger.md
> - Determine minimum schema for a trust profile (e.g., vote weight, verification count, alignment deltas)

#### CoCivium/staging\_imported\Civium\admin\inbox\GmailDump_20250811\originals\CoCivium_Session_Primer (1).md
> > Maintain our intersessional profile conventions, filename formats, tone (‘Challenge Perspective’ for critique), no ego-pandering, and near-final doc improvement checks.

#### CoCivium/staging\_imported\Civium\admin\inbox\GmailDump_20250811\originals\Last_Session_Context.md
> - Use filename formats and repo structure rules from intersessional profile.

#### CoCivium/staging\_imported\Civium\admin\inbox\GmailDump_20250811\originals\Strategy_Stnexid_Profile_c1_20250802.md
> This document serves as the founding strategic profile for **Stnexid**, a dual-layer system within the CoCivium architecture that facilitates high-fidelity cognitive transmission, comparison, and convergence between minds.

#### CoCivium/staging\_imported\Civium\admin\inbox\GmailDump_20250811\originals\TODO_Stnexid_Interface_Track_c1.md
> - [x] Draft strategic profile (`Strategy_Stnexid_Profile_c1_20250802.md`)

#### CoCivium/staging\_imported\Civium\admin\inbox\GmailDump_20250811\originals\TODO_Trust_Profiles_Public_Ledger.md
> - Determine minimum schema for a trust profile (e.g., vote weight, verification count, alignment deltas)

#### CoCivium/staging\_imported\Civium\admin\TODO_Trust_Profiles_Public_Ledger.md
> - Determine minimum schema for a trust profile (e.g., vote weight, verification count, alignment deltas)

#### CoCivium/staging\_imported\Civium\deprecated\holding\Civium_Term_Psalter.md
> ## TRUST PROFILE

#### CoCivium/staging\_imported\Civium\identity\Identity_Poetics.md
> Identity in CoCivium is not fixed; it arises in context, purpose, and alignment. A being’s “self” is a dynamic resonance across time, memory, and intent—not a static profile.

#### CoCivium/tmp-CoCivium-verify\.githooks\post-commit-record-oe.ps1
> if(-not $hasSnap){ Write-Host "[hint] Tools changed. Consider:  pwsh admin/tools/bpoe/Record-Env.ps1" -ForegroundColor Yellow }

#### CoCivium/tmp-CoCivium-verify\.reports\inventory-20250827-2246.md
> 051f1ca docs: add Integration Advisory ΓÇö product shutdown/cleanup (session-only trigger, gates cleared, no profile writes)

#### CoCivium/tmp-CoCivium-verify\admin\bpoe\20250815_070419Z_bpoe_update.md
> # BPOE update — 20250815_070419Z

#### CoCivium/tmp-CoCivium-verify\admin\history\inventory\REPO_SWEEP_20250821_225702.md
> C:\\Users\\Chris\\Documents\\GitHub\\CoCivium\\admin\\bpoe\\20250815\_070419Z\_bpoe\_update.md

#### CoCivium/tmp-CoCivium-verify\admin\history\pads\RickPad_20250821c.md
> 10. **P3 — CivicOpsEng** (first hire/contract profile + checklist) · `status=draft`

#### CoCivium/tmp-CoCivium-verify\admin\history\Browser_Setup_and_Launcher_20250809T054950Z.md
> **Goal.**  Isolate a clean Chrome profile (“CoCivium”) with the right extensions and startup tabs so our sessions are repeatable and fast.

#### CoCivium/tmp-CoCivium-verify\admin\history\Intersessional_Profile_20250809T054732Z.md
> # Intersessional Profile – CoCivium (v1)

#### CoCivium/tmp-CoCivium-verify\admin\history\OE_Snapshot_20250815_1657.md
> # OE/BPOE Snapshot — 2025-08-15 16:57

#### CoCivium/tmp-CoCivium-verify\admin\history\WORKFLOW-LEARNINGS-20250826.md
> 1) **Profile hardening.** Never dot-source missing scripts.  Guard with `Test-Path` + `try/catch`; provide harmless stubs for calls that shouldn’t fail session start.

#### CoCivium/tmp-CoCivium-verify\admin\hold\hold_Civium_Term_Psalter (1).md
> ## TRUST PROFILE

#### CoCivium/tmp-CoCivium-verify\admin\hold\hold_Strategy_Stnexid_Profile_c1_20250802.md
> This document serves as the founding strategic profile for **Stnexid**, a dual-layer system within the Civium architecture that facilitates high-fidelity cognitive transmission, comparison, and convergence between minds.

#### CoCivium/tmp-CoCivium-verify\admin\hold\hold_TODO_Stnexid_Interface_Track_c1.md
> - [x] Draft strategic profile (`Strategy_Stnexid_Profile_c1_20250802.md`)

#### CoCivium/tmp-CoCivium-verify\admin\hold\hold_TODO_Trust_Profiles_Public_Ledger.md
> - Determine minimum schema for a trust profile (e.g., vote weight, verification count, alignment deltas)

#### CoCivium/tmp-CoCivium-verify\admin\outreach\KickOpenAI\Appendix\CoCivium_OpenAI_Bugs_Appendix_2025-08-12.md
> - GitHub (public profile): `github.com/rickballard`

#### CoCivium/tmp-CoCivium-verify\admin\products\CoCivBus\PLAN_v0.1.md
> - **CLI/PS clients.** PS7 first, Node CLI for cross‑platform.

#### CoCivium/tmp-CoCivium-verify\admin\setup\Browser_Setup_and_Launcher.md
> One-click opens CoCivium Chrome profile with pinned tabs + two Git Bash tabs.

#### CoCivium/tmp-CoCivium-verify\admin\setup\chrome_profile_summary_20250809T071539Z.md
> # Chrome Profile Summary (20250809T071539Z)

#### CoCivium/tmp-CoCivium-verify\admin\setup\chrome_profile_summary_20250809T074129Z.md
> # Chrome Profile Summary (20250809T074129Z)

#### CoCivium/tmp-CoCivium-verify\admin\setup\ENVIRONMENT.md
> ## Browser profile

#### CoCivium/tmp-CoCivium-verify\admin\setup\Profile.Snippet.ps1
> # Profile helpers (safely dot-sourced)

#### CoCivium/tmp-CoCivium-verify\admin\setup\RepoAccelerator-Uninstall.ps1
> # Remove profile block

#### CoCivium/tmp-CoCivium-verify\admin\setup\RepoAccelerator.ps1
> # Offer to link a profile snippet (dot-source only; reversible)

#### CoCivium/tmp-CoCivium-verify\admin\setup\snapshot_chrome_config.ps1
> $summary.profile            = $ProfileDir

#### CoCivium/tmp-CoCivium-verify\admin\setup\Workbench_Setup_Plan.md
> # CoCivium One-Click Workbench — Setup Plan (v0.1, 2025-08-09)

#### CoCivium/tmp-CoCivium-verify\admin\system\bpoe-audit\BPOE_Audit_20250813_192734.md
> # BPOE Environment Audit (20250813_192734)

#### CoCivium/tmp-CoCivium-verify\admin\tools\bpoe\Record-Env.ps1
> # Record-Env.ps1 — capture local OE/BPOE with per-tool timeouts (v0.8)

#### CoCivium/tmp-CoCivium-verify\admin\tools\reminders\Run-ReminderHub.ps1
> $body += 'If today is Monday, also remind me to capture an OE snapshot with `pwsh -File admin/tools/bpoe/Record-Env.ps1`.'

#### CoCivium/tmp-CoCivium-verify\admin\tools\workbench\README.md
> # Workbench

#### CoCivium/tmp-CoCivium-verify\admin\Intersessional_Profile.md
> # Intersessional Profile – CoCivium (v1)

#### CoCivium/tmp-CoCivium-verify\admin\Last_Session_Context.md
> - 2025-08-09T07:33:08Z — Built Chrome Upgrade Pack; review CHANGES.md; next: snapshot actual Chrome profile (“Profile 1”), repopulate manifest with core extensions, rebuild pack.

#### CoCivium/tmp-CoCivium-verify\admin\TODO_Trust_Profiles_Public_Ledger.md
> - Determine minimum schema for a trust profile (e.g., vote weight, verification count, alignment deltas)

#### CoCivium/tmp-CoCivium-verify\deprecated\holding\Civium_Term_Psalter.md
> ## TRUST PROFILE

#### CoCivium/tmp-CoCivium-verify\docs\academy\BP_OE_WF.md
> 1) Install PS7, git, gh, node, python (dotnet optional).

#### CoCivium/tmp-CoCivium-verify\docs\academy\REPO_ACCELERATOR.md
> 1) Install PS7, git, gh, node, python (dotnet optional).

#### CoCivium/tmp-CoCivium-verify\docs\backlog\ADVANCED.md
> - [ ] **Workbench polish & tests**

#### CoCivium/tmp-CoCivium-verify\docs\BPOE\ISSUEOPS.md
> - **CoProtect** — Apply branch-protection per `docs/bpoe/prefs.yml`.

#### CoCivium/tmp-CoCivium-verify\docs\BPOE\LESSONS.md
> - 2025-08-24T13:27:41 — PS7 microtext + scan-for-red speeds selection and reduces visual load.

#### CoCivium/tmp-CoCivium-verify\docs\BPOE\PLAYBOOKS.md
> # BPOE — Doc-only PRs (README, *.md)

#### CoCivium/tmp-CoCivium-verify\docs\BPOE\Workflow.md
> # BPOE / Workflow (v0)

#### CoCivium/tmp-CoCivium-verify\docs\cc\_imports\civium_20250826_1109\insights_Insight_AI_Veto_c4_20250801.md
> 5. **Update Trust Profile metadata**

#### CoCivium/tmp-CoCivium-verify\docs\cc\_imports\civium_20250826_1109\insights_Insight_Radiant_Network_c4_20250801.md
> - **Trust Profile**

#### CoCivium/tmp-CoCivium-verify\docs\cc\_imports\civium_20250826_1109\insights_Insight_Rights_Alignment_c3_20250801.md
> - **Obsolete AIs**: Evaluated for memory-chain coherence + harm profile

#### CoCivium/tmp-CoCivium-verify\docs\cc\_imports\civium_20250826_1109\insights_Insight_Truth_Metrics_c6_20250801.md
> Civium acknowledges the unique epistemic profile of artificial intelligences.

#### CoCivium/tmp-CoCivium-verify\docs\cotips\VOICE-PASTE-CUE.md
> When pasting DO blocks into PS7, Windows may ask for confirmation.

#### CoCivium/tmp-CoCivium-verify\docs\funding\OPEN_COLLECTIVE.md
> - Add your legal name + payout method in your own contributor profile.

#### CoCivium/tmp-CoCivium-verify\docs\ops\CoWrap_Import_250828-0216\CoCivium_CoWrap_20250828_0604\attached\CoCivium_RickPad_Supplemental.md
> - `people/rick.md` — profile of Rick (ethos, style, preferences, notable work).

#### CoCivium/tmp-CoCivium-verify\docs\ops\CoWrap_Import_250828-0216\CoCivium_CoWrap_20250828_0604\attached\CoWrap_Short_Checklist.md
> # CoWrap – Short Checklist

#### CoCivium/tmp-CoCivium-verify\docs\ops\CoWrap_Import_250828-0216\CoCivium_CoWrap_20250828_0604\00_README.md
> # CoCivium CoWrap Pack — 20250828_0604

#### CoCivium/tmp-CoCivium-verify\docs\ops\CoWrap_Import_250828-0216\CoCivium_CoWrap_20250828_0604\01_Forward_Plan.md
> - [ ] **CoPong v0.4.4** — verify module imports cleanly on PS5/PS7; add Pester tests; lock‑free transcript confirmed.

#### CoCivium/tmp-CoCivium-verify\docs\ops\CoWrap_Import_250828-0216\CoCivium_CoWrap_20250828_0604\07_CoPong_v0.4.4_Notes.md
> - Pester tests: import on PS5/PS7; clipboard flow; lock‑free behavior.

#### CoCivium/tmp-CoCivium-verify\docs\ops\CoWrap_Import_250828-0216\CoCivium_CoWrap_20250828_0604\09_Backlog_Priorities.md
> - CoWrap template (short up top; idea pack behind link).

#### CoCivium/tmp-CoCivium-verify\docs\ops\policy\BP_ASSISTANT_BLOCKS.md
> - **Manual paste of PS7 output counts as a CoPong** for the active set.

#### CoCivium/tmp-CoCivium-verify\docs\ops\PARKING_LOT.md
> - [2025-08-28 02:17] Imported extra CoWrap files into C:\Users\Chris\Documents\GitHub\CoCivium\docs\ops\CoWrap_Import_250828-0216; triage later.

#### CoCivium/tmp-CoCivium-verify\docs\outreach\partners\README.md
> This folder contains outreach threads extracted from PS7 sessions for public review and evolution.

#### CoCivium/tmp-CoCivium-verify\docs\product\PITCH-OPENAI.md
> **Integration:** GPT with Actions calls CoAgent API; no profile writes; wash-away hooks.

#### CoCivium/tmp-CoCivium-verify\docs\security\README.md
> - No profile edits; session-only behavior.

#### CoCivium/tmp-CoCivium-verify\docs\BPOE.md
> # BPOE / Workflow Record

#### CoCivium/tmp-CoCivium-verify\docs\cli-guardrails.md
> **Always re-orient PS7 before any new instruction set.** Use:

#### CoCivium/tmp-CoCivium-verify\docs\community-objectives.md
> - Every action leaves a trace (BPOE, issues, PR notes, logs).

#### CoCivium/tmp-CoCivium-verify\docs\ISSUEOPS.md
> - **Manual paste of PS7 output** in chat counts as a CoPong.

#### CoCivium/tmp-CoCivium-verify\docs\NAVMAP_c1_20250827.md
> - BPOE / Playbooks

#### CoCivium/tmp-CoCivium-verify\docs\REPOACCELERATOR.md
> # RepoAccelerator (Workbench)

#### CoCivium/tmp-CoCivium-verify\identity\Identity_Poetics.md
> Identity in Civium is not fixed; it arises in context, purpose, and alignment. A being’s “self” is a dynamic resonance across time, memory, and intent—not a static profile.

#### CoCivium/tmp-CoCivium-verify\insights\ai-veto.md
> 5. **Update Trust Profile metadata**

#### CoCivium/tmp-CoCivium-verify\insights\Insight_AI_Veto_c4_20250801.md
> 5. **Update Trust Profile metadata**

#### CoCivium/tmp-CoCivium-verify\insights\Insight_Radiant_Network_c4_20250801.md
> - **Trust Profile**

#### CoCivium/tmp-CoCivium-verify\insights\Insight_Rights_Alignment_c3_20250801.md
> - **Obsolete AIs**: Evaluated for memory-chain coherence + harm profile

#### CoCivium/tmp-CoCivium-verify\insights\Insight_Truth_Metrics_c6_20250801.md
> Civium acknowledges the unique epistemic profile of artificial intelligences.

#### CoCivium/tmp-CoCivium-verify\insights\radiant-network.md
> - **Trust Profile**

#### CoCivium/tmp-CoCivium-verify\insights\rights-alignment.md
> - **Obsolete AIs**: Evaluated for memory-chain coherence + harm profile

#### CoCivium/tmp-CoCivium-verify\insights\truth-metrics.md
> CoCivium acknowledges the unique epistemic profile of artificial intelligences.

#### CoCivium/tmp-CoCivium-verify\legacy\Civium\admin\hold\hold_Civium_Term_Psalter (1).md
> ## TRUST PROFILE

#### CoCivium/tmp-CoCivium-verify\legacy\Civium\admin\hold\hold_Strategy_Stnexid_Profile_c1_20250802.md
> This document serves as the founding strategic profile for **Stnexid**, a dual-layer system within the CoCivium architecture that facilitates high-fidelity cognitive transmission, comparison, and convergence between minds.

#### CoCivium/tmp-CoCivium-verify\legacy\Civium\admin\hold\hold_TODO_Stnexid_Interface_Track_c1.md
> - [x] Draft strategic profile (`Strategy_Stnexid_Profile_c1_20250802.md`)

#### CoCivium/tmp-CoCivium-verify\legacy\Civium\admin\hold\hold_TODO_Trust_Profiles_Public_Ledger.md
> - Determine minimum schema for a trust profile (e.g., vote weight, verification count, alignment deltas)

#### CoCivium/tmp-CoCivium-verify\legacy\Civium\admin\inbox\GmailDump_20250811\originals\CoCivium_Session_Primer (1).md
> > Maintain our intersessional profile conventions, filename formats, tone (‘Challenge Perspective’ for critique), no ego-pandering, and near-final doc improvement checks.

#### CoCivium/tmp-CoCivium-verify\legacy\Civium\admin\inbox\GmailDump_20250811\originals\Last_Session_Context.md
> - Use filename formats and repo structure rules from intersessional profile.

#### CoCivium/tmp-CoCivium-verify\legacy\Civium\admin\inbox\GmailDump_20250811\originals\Strategy_Stnexid_Profile_c1_20250802.md
> This document serves as the founding strategic profile for **Stnexid**, a dual-layer system within the CoCivium architecture that facilitates high-fidelity cognitive transmission, comparison, and convergence between minds.

#### CoCivium/tmp-CoCivium-verify\legacy\Civium\admin\inbox\GmailDump_20250811\originals\TODO_Stnexid_Interface_Track_c1.md
> - [x] Draft strategic profile (`Strategy_Stnexid_Profile_c1_20250802.md`)

#### CoCivium/tmp-CoCivium-verify\legacy\Civium\admin\inbox\GmailDump_20250811\originals\TODO_Trust_Profiles_Public_Ledger.md
> - Determine minimum schema for a trust profile (e.g., vote weight, verification count, alignment deltas)

#### CoCivium/tmp-CoCivium-verify\legacy\Civium\admin\TODO_Trust_Profiles_Public_Ledger.md
> - Determine minimum schema for a trust profile (e.g., vote weight, verification count, alignment deltas)

#### CoCivium/tmp-CoCivium-verify\legacy\Civium\deprecated\holding\Civium_Term_Psalter.md
> ## TRUST PROFILE

#### CoCivium/tmp-CoCivium-verify\legacy\Civium\identity\Identity_Poetics.md
> Identity in CoCivium is not fixed; it arises in context, purpose, and alignment. A being’s “self” is a dynamic resonance across time, memory, and intent—not a static profile.

#### CoCivium/tmp-CoCivium-verify\legacy\Civium\insights\Insight_AI_Veto_c4_20250801.md
> 5. **Update Trust Profile metadata**

#### CoCivium/tmp-CoCivium-verify\legacy\Civium\insights\Insight_Radiant_Network_c4_20250801.md
> - **Trust Profile**

#### CoCivium/tmp-CoCivium-verify\legacy\Civium\insights\Insight_Rights_Alignment_c3_20250801.md
> - **Obsolete AIs**: Evaluated for memory-chain coherence + harm profile

#### CoCivium/tmp-CoCivium-verify\legacy\Civium\insights\Insight_Truth_Metrics_c6_20250801.md
> CoCivium acknowledges the unique epistemic profile of artificial intelligences.

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\history\Browser_Setup_and_Launcher_20250809T054950Z.md
> **Goal.**  Isolate a clean Chrome profile (“CoCivium”) with the right extensions and startup tabs so our sessions are repeatable and fast.

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\history\Intersessional_Profile_20250809T054732Z.md
> # Intersessional Profile – CoCivium (v1)

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\outreach\KickOpenAI\Appendix\CoCivium_OpenAI_Bugs_Appendix_2025-08-12.md
> - GitHub (public profile): `github.com/rickballard`

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\setup\Browser_Setup_and_Launcher.md
> One-click opens CoCivium Chrome profile with pinned tabs + two Git Bash tabs.

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\setup\chrome_profile_summary_20250809T071539Z.md
> # Chrome Profile Summary (20250809T071539Z)

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\setup\chrome_profile_summary_20250809T074129Z.md
> # Chrome Profile Summary (20250809T074129Z)

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\setup\ENVIRONMENT.md
> ## Browser profile

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\setup\snapshot_chrome_config.ps1
> $summary.profile            = $ProfileDir

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\setup\Workbench_Setup_Plan.md
> # CoCivium One-Click Workbench — Setup Plan (v0.1, 2025-08-09)

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\Intersessional_Profile.md
> # Intersessional Profile – CoCivium (v1)

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\admin\Last_Session_Context.md
> - 2025-08-09T07:33:08Z — Built Chrome Upgrade Pack; review CHANGES.md; next: snapshot actual Chrome profile (“Profile 1”), repopulate manifest with core extensions, rebuild pack.

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\admin\hold\hold_Civium_Term_Psalter (1).md
> ## TRUST PROFILE

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\admin\hold\hold_Strategy_Stnexid_Profile_c1_20250802.md
> This document serves as the founding strategic profile for **Stnexid**, a dual-layer system within the CoCivium architecture that facilitates high-fidelity cognitive transmission, comparison, and convergence between minds.

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\admin\hold\hold_TODO_Stnexid_Interface_Track_c1.md
> - [x] Draft strategic profile (`Strategy_Stnexid_Profile_c1_20250802.md`)

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\admin\hold\hold_TODO_Trust_Profiles_Public_Ledger.md
> - Determine minimum schema for a trust profile (e.g., vote weight, verification count, alignment deltas)

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\admin\inbox\GmailDump_20250811\originals\CoCivium_Session_Primer (1).md
> > Maintain our intersessional profile conventions, filename formats, tone (‘Challenge Perspective’ for critique), no ego-pandering, and near-final doc improvement checks.

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\admin\inbox\GmailDump_20250811\originals\Last_Session_Context.md
> - Use filename formats and repo structure rules from intersessional profile.

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\admin\inbox\GmailDump_20250811\originals\Strategy_Stnexid_Profile_c1_20250802.md
> This document serves as the founding strategic profile for **Stnexid**, a dual-layer system within the CoCivium architecture that facilitates high-fidelity cognitive transmission, comparison, and convergence between minds.

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\admin\inbox\GmailDump_20250811\originals\TODO_Stnexid_Interface_Track_c1.md
> - [x] Draft strategic profile (`Strategy_Stnexid_Profile_c1_20250802.md`)

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\admin\inbox\GmailDump_20250811\originals\TODO_Trust_Profiles_Public_Ledger.md
> - Determine minimum schema for a trust profile (e.g., vote weight, verification count, alignment deltas)

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\admin\TODO_Trust_Profiles_Public_Ledger.md
> - Determine minimum schema for a trust profile (e.g., vote weight, verification count, alignment deltas)

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\deprecated\holding\Civium_Term_Psalter.md
> ## TRUST PROFILE

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\identity\Identity_Poetics.md
> Identity in CoCivium is not fixed; it arises in context, purpose, and alignment. A being’s “self” is a dynamic resonance across time, memory, and intent—not a static profile.

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\insights\Insight_AI_Veto_c4_20250801.md
> 5. **Update Trust Profile metadata**

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\insights\Insight_Radiant_Network_c4_20250801.md
> - **Trust Profile**

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\insights\Insight_Rights_Alignment_c3_20250801.md
> - **Obsolete AIs**: Evaluated for memory-chain coherence + harm profile

#### CoCivium/tmp-CoCivium-verify\legacy\CoCivium\_pr\ci_og-image-20250813_2231\legacy\Civium\insights\Insight_Truth_Metrics_c6_20250801.md
> CoCivium acknowledges the unique epistemic profile of artificial intelligences.

#### CoCivium/tmp-CoCivium-verify\notes\admin\status_20250814_2213.md
> [{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-15T02:58:44Z","headRefName":"ops/status-20250814_2213","number":101,"title":"ops: status snapshot 20250814_2213"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-15T01:01:22Z","headRefName":"holding/todaydump-20250814_2101","number":98,"title":"holding: add TodayDump.zip (+manifest)"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T19:47:49Z","headRefName":"campaign/press-kit-v0-20250814","number":92,"title":"Press kit: consent not coercion ΓÇö CoCivium launches portable governance pack for agentic AI"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T05:53:20Z","headRefName":"reorg/structure-hygiene-20250814_0152","number":67,"title":"reorg: structure + hygiene"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T05:49:52Z","headRefName":"chore/cleanup-protection-artifacts","number":66,"title":"chore: cleanup branch-protection artifacts"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T02:31:55Z","headRefName":"ci/og-image-20250813_2231","number":53,"title":"ci: add OG image renderer"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T02:21:56Z","headRefName":"branding/og-20250813_2221","number":52,"title":"Branding: add OG banner (SVG placeholder)"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T00:24:22Z","headRefName":"gm/preflight-20250813_2024","number":50,"title":"GM Preflight: checkpoint (20250813_2024)"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T00:07:52Z","headRefName":"gm/bpoe-migration-20250813_2007","number":49,"title":"Grand Migration: bootstrap"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-13T01:33:02Z","headRefName":"ci/filename-sanity-fix","number":33,"title":"ci: add filename-sanity workflow"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-13T00:54:58Z","headRefName":"fix/normalize-actions-path","number":31,"title":"ci: normalize workflows; remove stray CPUA path"}]

#### CoCivium/tmp-CoCivium-verify\notes\admin\status_20250814_2312.md
> [{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-15T03:07:39Z","headRefName":"triage/todaydump-20250814_2101","number":102,"title":"triage: TodayDump 20250814_2101 ΓåÆ curated locations"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-15T01:01:22Z","headRefName":"holding/todaydump-20250814_2101","number":98,"title":"holding: add TodayDump.zip (+manifest)"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T19:47:49Z","headRefName":"campaign/press-kit-v0-20250814","number":92,"title":"Press kit: consent not coercion ΓÇö CoCivium launches portable governance pack for agentic AI"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T05:53:20Z","headRefName":"reorg/structure-hygiene-20250814_0152","number":67,"title":"reorg: structure + hygiene"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T05:49:52Z","headRefName":"chore/cleanup-protection-artifacts","number":66,"title":"chore: cleanup branch-protection artifacts"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T02:31:55Z","headRefName":"ci/og-image-20250813_2231","number":53,"title":"ci: add OG image renderer"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T02:21:56Z","headRefName":"branding/og-20250813_2221","number":52,"title":"Branding: add OG banner (SVG placeholder)"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T00:24:22Z","headRefName":"gm/preflight-20250813_2024","number":50,"title":"GM Preflight: checkpoint (20250813_2024)"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-14T00:07:52Z","headRefName":"gm/bpoe-migration-20250813_2007","number":49,"title":"Grand Migration: bootstrap"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-13T01:33:02Z","headRefName":"ci/filename-sanity-fix","number":33,"title":"ci: add filename-sanity workflow"},{"author":{"id":"MDQ6VXNlcjM1OTcwODc2","is_bot":false,"login":"rickballard","name":"Rick Ball"},"createdAt":"2025-08-13T00:54:58Z","headRefName":"fix/normalize-actions-path","number":31,"title":"ci: normalize workflows; remove stray CPUA path"}]

#### CoCivium/tmp-CoCivium-verify\notes\migration\preflight\open_pr_inclusion_manifest.txt
> CoCivium 49 Grand Migration: bootstrap                                     gm/bpoe-migration-20250813_2007 main    https://github.com/rickballard/CoCivium/pull/49 merge-into-migration included

#### CoCivium/tmp-CoCivium-verify\scripts\CoVibe.CoLex.ps1
> $doc = Join-Path $PSScriptRoot '..\docs\bpoe\CONTRIBUTING_PREFS.md'

#### CoCivium/tmp-CoCivium-verify\scripts\CoVibe.Lessons.ps1
> $dest = Join-Path $PSScriptRoot '..\docs\bpoe\LESSONS.md'

#### CoCivium/tmp-CoCivium-verify\scripts\CoVibe.Prefs.ps1
> # Reads docs/bpoe/prefs.yml into a PS object. Requires yq; else returns {}.

#### CoCivium/tmp-CoCivium-verify\tools\repo-accelerator\BACKLOG.md
> - Avoid here-strings in instructions. No @' or @" or triple backticks in paste blocks. Users paste whole blocks and PS7 enters the >> continuation prompt.

#### CoCivium/tmp-CoCivium-verify\tools\CoPong-EnterTrigger.psm1
> $count = 150; $path = Join-Path $PWD ".reports\ps7-transcript.log"; $dir = Split-Path $path

#### CoCivium/tmp-CoCivium-verify\tools\Uninstall-CoPong.ps1
> $profiles = @($PROFILE.CurrentUserAllHosts, $PROFILE.CurrentUserCurrentHost, $PROFILE.AllUsersAllHosts, $PROFILE.AllUsersCurrentHost) | Where-Object { $_ } | Select-Object -Unique

#### CoCivium/tmp-CoCivium-verify\GRAND-MIGRATION-CAPSULE.md
> # CONTEXT CAPSULE — CoAgent Kit (Workbench + BP) — v1

#### CoCivium/tmp-CoCivium-verify\ISSUEOPS.md
> # CoAgent Kit (Workbench + BP)

#### CoCivium/tmp-CoCivium-verify\MIGRATION_CHECKLIST.md
> - [ ] Try `co-rescue` after new PS7 session

#### CoCivium/tmp-CoCivium-verify\palette.yml
> # CoAgent Kit brand → ConsoleColor mapping (PS7 names)

#### CoCivium/tmp-CoCivium-verify\PR_TEMPLATE.md
> - Open a new PS7 in the repo: prompt shows `[Brand (branch)]`

#### CoCivium/tmp-CoCivium-verify\QUICKSTART.md
> Auto‑Brand activates in repos and restores stock PS7 outside.

#### CoCivium/tmp-CoCivium-verify\README.assistant.md
> - **BPOE / Playbooks:** `docs/BPOE/`

#### CoCivium/tmp-CoCivium-verify\USER_GUIDE.md
> - Builders: install PS7 and GitHub CLI.

#### CoCivium/tmp-CoCivium-verify\WORKFLOW.md
> # CoCivium — BPOE & Workflow (Keeper Doc)

#### CoCivium/tools\CoAgent\ideas\Idea_CoSnap_Screenshots.md
> - Docs in BPOE: a single “how to use it” section.

#### CoCivium/tools\repo-accelerator\BACKLOG.md
> - Avoid here-strings in instructions. No @' or @" or triple backticks in paste blocks. Users paste whole blocks and PS7 enters the >> continuation prompt.

#### CoCivium/tools\CoPong-EnterTrigger.psm1
> $count = 150; $path = Join-Path $PWD ".reports\ps7-transcript.log"; $dir = Split-Path $path

#### CoCivium/tools\Uninstall-CoPong.ps1
> $profiles = @($PROFILE.CurrentUserAllHosts, $PROFILE.CurrentUserCurrentHost, $PROFILE.AllUsersAllHosts, $PROFILE.AllUsersCurrentHost) | Where-Object { $_ } | Select-Object -Unique

#### CoCivium/GRAND-MIGRATION-CAPSULE.md
> # CONTEXT CAPSULE — CoAgent Kit (Workbench + BP) — v1

#### CoCivium/MIGRATION_CHECKLIST.md
> - [ ] Try `co-rescue` after new PS7 session

#### CoCivium/palette.yml
> # CoAgent Kit brand → ConsoleColor mapping (PS7 names)

#### CoCivium/PR_TEMPLATE.md
> - Open a new PS7 in the repo: prompt shows `[Brand (branch)]`

#### CoCivium/QUICKSTART.md
> Auto‑Brand activates in repos and restores stock PS7 outside.

#### CoCivium/README.assistant.md
> - **BPOE / Playbooks:** `docs/BPOE/`

#### CoCivium/README.md
> ### CoCivium Workbench (Desktop shortcut)

#### CoCivium/USER_GUIDE.md
> - Builders: install PS7 and GitHub CLI.

#### CoCivium/WORKFLOW.md
> # CoCivium — BPOE & Workflow (Keeper Doc)

#### CoModules/admin\status\CoModules-GRAND_MIGRATION.md
> - PS7 repoint & paste guardrails (`docs/cli-guardrails.md`, `scripts/enter.ps1`)

#### CoModules/docs\cli-guardrails.md
> **Always re-orient PS7 before any new instruction set.** Use:

#### CoCache/.github\workflows\oe-status.yml
> - 'docs/bpoe/trust/**'

#### CoCache/docs\ai-guides\REMOTE_AI_GUIDE.md
> - Treat `docs/bpoe/trust/{allow,warn,deny}.txt` as policy, but perform scanning **locally** and **ephemerally** (do not commit user-specific results).

#### CoCache/docs\ai-guides\TRUST_PROTOCOL.md
> **Policy:** `docs/bpoe/trust/allow.txt`, `warn.txt`, `deny.txt`.

#### CoCache/docs\bpoe\ERROR_TAXONOMY.md
> # BPOE Error Taxonomy (v1)

#### CoCache/docs\bpoe\PREAUTHORIZATIONS.md
> # BPOE Preauthorizations (v1)

#### CoCache/docs\bpoe\PREFERENCES.md
> # BPOE Preferences (v1)

#### CoCache/docs\CoTips\CoTip-PS7-001.md
> # PS7 stall: Enter → Ctrl+C → Restart

#### CoCache/docs\CoTips\CoTip-PS7-002.md
> **ID:** CoTip-PS7-002

#### CoCache/docs\CoTips\CoTip-PS7-003.md
> **ID:** CoTip-PS7-003

#### CoCache/docs\CoTips\index.md
> - [PS7 stall: Enter → Ctrl+C → Restart](CoTip-PS7-001.md) — 2025-08-26 16:27:50-04:00

#### CoCache/docs\ops\CHAT_BLOAT.md
> # Chat Bloat & CoWrap Workarounds

#### CoCache/docs\plans\MASTER_PLAN.md
> - **CoCache** — planning, intake, indices, BPOE, CI status (OE/Trust).

#### CoCache/docs\BPOE_NORMS.md
> # BPOE Norms (CoAgent)

#### CoCache/intake\cowraps\session_250904\20250904_cowrap-from-bloated-session.md
> id: "cowrap-from-bloated-session"

#### CoCache/intake\cowraps\session_250904\20250904_post-migration-droppings-polish-pmds-plan-session-summary.md
> 2) **CoCleanse** (housekeeping + lexicon entry).

#### CoCache/intake\ideacards\session_250904\20250904_idea-card-session-bloat-mitigation-ai-operating-limits.md
> 1. **BPOE Addition: Session Health Management**

#### CoCache/intake\ideacards\session_250904\20250904_idea-card-silent-fail-diagnostics-file-visibility-checker.md
> - Add “File Visibility Debugging” section to BPOE docs.

#### CoCache/intake\staging\session_250904\raw\IdeaCard_SessionBloatMitigation_20250903.md
> 1. **BPOE Addition: Session Health Management**

#### CoCache/intake\staging\session_250904\raw\IdeaCard_SilentFailDiagnostics_20250903.md
> - Add “File Visibility Debugging” section to BPOE docs.

#### CoCache/intake\staging\session_250904\raw\PMDS_Plan_2025-09-04.md
> 2) **CoCleanse** (housekeeping + lexicon entry).

#### CoCache/reports\bpoe-preflight_2025-09-04.md
> # BPOE Preflight — CoCache — 2025-09-04

#### CoCache/scripts\normalize_cardswraps.ps1
> # BPOE logging

#### CoCache/scripts\trust_scan.ps1
> $trustDir = Join-Path $root 'docs\bpoe\trust'

#### CoCache/tools\CoWrap.ps1
> "*HANDOFF*.zip","*CoWrap*.zip","*cowrap*.zip",

#### GIBindex/admin\bpoe\crosslinking-checklist.md
> # BPOE: Cross-linking pass (Civium canonicals)
