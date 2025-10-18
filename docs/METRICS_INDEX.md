# CoSuite Metrics & Watchers Index

_Generated: 2025-10-17 22:53:29Z_

## Metrics (from registry)
| status | id | cadence | latest ts | latest fields | history | log |
|---|---|---|---|---|---|---|
| ![](assets/brand/cocivium_logo_gray_tm.svg) | heartbeat.core | on-demand |  |  | [metrics/history/heartbeat.core.csv](metrics/history/heartbeat.core.csv) | [docs/HEARTBEATS/heartbeat.log](docs/HEARTBEATS/heartbeat.log) |
| ![](assets/brand/cocivium_logo_gray_tm.svg) | git.sanity.cocache | on-demand |  |  | [metrics/history/git.sanity.cocache.csv](metrics/history/git.sanity.cocache.csv) | [docs/HEARTBEATS/git_cocache.log](docs/HEARTBEATS/git_cocache.log) |
| ![](assets/brand/cocivium_logo_gray_tm.svg) | git.sanity.inseed | on-demand |  |  | [metrics/history/git.sanity.inseed.csv](metrics/history/git.sanity.inseed.csv) | [../InSeed/docs/HEARTBEATS/git_inseed.log](../InSeed/docs/HEARTBEATS/git_inseed.log) |

## Heartbeats & CoPingPong
- docs/HEARTBEATS/copings.log (size: 0.2 KB, last: 2025-10-17T17:28:19Z)
- docs/HEARTBEATS/git_cocache.log (size: 0.1 KB, last: 2025-10-17T18:26:35Z)
- docs/HEARTBEATS/git_inseed.log (size: 0.1 KB, last: 2025-10-17T18:26:35Z)
- docs/HEARTBEATS/heartbeat.log (size: 0.3 KB, last: 2025-10-17T17:28:17Z)

## Launchers & Jobs (workflows + scripts)

### CoCache
- Workflows:
  - actionlint — .github/workflows/actionlint.yml
  - auto-add-to-project — .github/workflows/auto-add-to-project.yml
  - bpoe-safety-gate — .github/workflows/bpoe-safety-gate.yml
  - bpoe-sanity — .github/workflows/bpoe-sanity.yml
  - bpoe-self-evolve — .github/workflows/bpoe-self-evolve.yml
  - bpoe-smoke — .github/workflows/bpoe-smoke.yml
  - civium-safety — .github/workflows/civium-safety.yml
  - coindex — .github/workflows/coindex.yml
  - congruence — .github/workflows/congruence.yml
  - hygiene — .github/workflows/hygiene.yml
  - initiatives-scan — .github/workflows/initiatives-scan.yml
  - intake-validate — .github/workflows/intake-validate.yml
  - metrics-daily — .github/workflows/metrics-daily.yml
  - metrics-harvest — .github/workflows/metrics-harvest.yml
  - oe-status — .github/workflows/oe-status.yml
  - ops-heartbeat-smoke — .github/workflows/ops-heartbeat-smoke.yml
  - pages — .github/workflows/pages.yml
  - readme-lock — .github/workflows/readme-lock.yml
  - readme-smoke — .github/workflows/readme-smoke.yml
  - triage-guard — .github/workflows/triage-guard.yml
  - va-index — .github/workflows/va-index.yml
  - zz-smoke-simple — .github/workflows/zz-smoke-simple.yml
- Scripts:
  - scripts/BN_Canonical_Pull.ps1 (last: 2025-10-07T06:47:32Z)
  - scripts/CC_InlineCores.ps1 (last: 2025-10-07T06:47:32Z)
  - scripts/Ensure-AbBypass.ps1 (last: 2025-10-05T23:28:56Z)
  - scripts/metrics_badges.ps1 (last: 2025-10-17T21:15:17Z)
  - scripts/metrics_harvest.ps1 (last: 2025-10-17T16:58:31Z)
  - scripts/metrics_index_inject_badges.ps1 (last: 2025-10-17T20:01:07Z)
  - scripts/metrics_index.ps1 (last: 2025-10-18T00:51:35Z)
  - scripts/metrics_stale_check.ps1 (last: 2025-10-17T18:26:33Z)
  - scripts/metrics_trends.ps1 (last: 2025-10-17T19:24:32Z)
  - scripts/normalize_cardswraps.ps1 (last: 2025-09-15T21:05:46Z)
  - scripts/oe_status.ps1 (last: 2025-09-15T21:05:46Z)
  - scripts/render_sparklines.ps1 (last: 2025-10-17T18:26:37Z)
  - scripts/trust_scan.ps1 (last: 2025-09-15T21:05:46Z)

### InSeed
- Workflows:
  - analytics-digest — .github/workflows/analytics-digest.yml
  - pages — .github/workflows/pages.yml
  - safety-gate — .github/workflows/safety-gate.yml
  - self-evolve — .github/workflows/self-evolve.yml
  - smoke — .github/workflows/smoke.yml
- Scripts:
  - scripts/Apply-InSeed-Polish.ps1 (last: 2025-09-23T19:59:12Z)
  - scripts/AutoBadge-Status.ps1 (last: 2025-09-23T19:59:12Z)
  - scripts/Ensure-Assets-Manifest.ps1 (last: 2025-09-23T19:59:12Z)
  - scripts/Ensure-Block.ps1 (last: 2025-09-23T19:59:12Z)
  - scripts/ingest-diagrams.ps1 (last: 2025-10-17T00:17:36Z)

### CoCivium
- Workflows:
  - ai-ideacard-weekly — .github/workflows/ai-ideacard-weekly.yml
  - auto-add-to-project — .github/workflows/auto-add-to-project.yml
  - bpoe-auto-crumb — .github/workflows/bpoe-auto-crumb.yml
  - bpoe-guard — .github/workflows/bpoe-guard.yml
  - cc-megascroll — .github/workflows/cc-megascroll.yml
  - ci-advisory — .github/workflows/ci-advisory.yml
  - codespell — .github/workflows/codespell.yml
  - decision-log-linter — .github/workflows/decision-log-linter.yml
  - drift-watch — .github/workflows/drift-watch.yml
  - eol-check — .github/workflows/eol-check.yml
  - guard — .github/workflows/guard.yml
  - insights-validate — .github/workflows/insights-validate.yml
  - label-grand-migration — .github/workflows/label-grand-migration.yml
  - labeler — .github/workflows/labeler.yml
  - link-check — .github/workflows/link-check.yml
  - linkcheck — .github/workflows/linkcheck.yml
  - markdownlint — .github/workflows/markdownlint.yml
  - nasties-guard — .github/workflows/nasties-guard.yml
  - noname-stubs-check — .github/workflows/noname-stubs-check.yml
  - og-starfield — .github/workflows/og-starfield.yml
  - pages — .github/workflows/pages.yml
  - pr-labeler — .github/workflows/pr-labeler.yml
  - quality — .github/workflows/quality.yml
  - readme-lock — .github/workflows/readme-lock.yml
  - readme-noname-check — .github/workflows/readme-noname-check.yml
  - readme-smoke — .github/workflows/readme-smoke.yml
  - render-eyes — .github/workflows/render-eyes.yml
  - render-og-png — .github/workflows/render-og-png.yml
  - safety-gate — .github/workflows/safety-gate.yml
  - seed-tag-guard — .github/workflows/seed-tag-guard.yml
  - succession-guardian — .github/workflows/succession-guardian.yml
  - symbol-guard — .github/workflows/symbol-guard.yml
  - sync-profile — .github/workflows/sync-profile.yml
  - user-heartbeat — .github/workflows/user-heartbeat.yml
  - yamllint — .github/workflows/yamllint.yml
- Scripts:
  - scripts/Build-CCMegascroll.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/check-encoding.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/CoBloat.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/CoBloatWatch.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/CoPingHeartbeat.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/CoVibe.AbsLink.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/CoVibe.ApplyProtection.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/CoVibe.Blocks.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/CoVibe.Brand.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/CoVibe.CoLex.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/CoVibe.CoLex.ps1.bak.20250826_083033 (last: 2025-10-06T00:42:45Z)
  - scripts/CoVibe.CopyShield.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/CoVibe.Lessons.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/CoVibe.Metrics.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/CoVibe.Prefs.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/diagnose_readme_v2.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/diagnose_readme_v3_fix.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/diagnose_readme_v3.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/diagnose_readme.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/DO_EnforceProtection.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/DO_VerifyProtection.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/emergency-merge.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/enter.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/find_clean_readme_v2.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/find_clean_readme_v3.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/find_clean_readme.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/gen_ideacard.mjs (last: 2025-10-06T00:42:45Z)
  - scripts/generate_og.py (last: 2025-10-06T00:42:45Z)
  - scripts/lint.links.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/new-idea.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/New-StatusSnapshot.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/readme_fix.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/readme_lint.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/repair_readme_v2.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/repair_readme.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/sanitize_readme.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/smoke.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/stubscan.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/update_readme_new.ps1 (last: 2025-10-06T00:42:45Z)
  - scripts/Validate-FrontMatter.ps1 (last: 2025-10-06T00:42:45Z)

### CoPolitic
- Workflows:
  - lead-alert — .github/workflows/lead-alert.yml
  - link-check — .github/workflows/link-check.yml
  - pages-smoke — .github/workflows/pages-smoke.yml
  - pages — .github/workflows/pages.yml
- Scripts:
  - scripts/apply-logos.ps1 (last: 2025-09-27T00:57:56Z)
  - scripts/check-cache.ps1 (last: 2025-09-25T21:26:34Z)
  - scripts/logo-audit-fast.ps1 (last: 2025-09-26T21:45:05Z)
  - scripts/logo-audit.ps1 (last: 2025-09-26T21:20:37Z)

### CoSteward
- Workflows:
  - ops-heartbeat-smoke — .github/workflows/ops-heartbeat-smoke.yml
  - zz-smoke-simple — .github/workflows/zz-smoke-simple.yml

## Notes
- Regenerate: pwsh -File scripts/metrics_index.ps1
- Retention: 90 days via scripts/metrics_harvest.ps1
- Staged scripts manifest: metrics/coops_manifest.json
